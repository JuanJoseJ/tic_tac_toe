import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:tic_tac_toe/util/game_data_class.dart';

class RealtimeDBSerice {
  /// Así va a funcionar el online game:
  /// Cuando un jugador inicia una partida online, se le asigna un código que debe ser usado como referencia
  /// para unirse. Osea, buscar en la base de datos un juego con dicho código. En caso de que haya uno abierto
  /// con esa código, el jugador se unirá con unas fichas.
  /// Al finalizar la partida, se reinician los valores para jugar de nuevo..
  /// Debe manejarse por ahora las id's de los jugadores de manera generica. Luego se implementaran id's de usuario.
  /// Casos:
  /// - Una partida está abierta pero le falta un jugador.
  /// - Una partida está llena. En cuyo caso no se permitirá verla.
  /// - No hay partidas encontradas.

  Function(GameData) onGameChanged = (gd) {};
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _gameSubscription;
  RealtimeDBSerice(this.onGameChanged);

  // Listen to changes in game data
  void listenToGameChanges(String gameId) {
    try {
      _gameSubscription =
          _database.child("games/$gameId/gameData").onValue.listen((event) {
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.exists) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(dataSnapshot.value as Map);
          GameData gameData = GameData.fromMap(data);
          onGameChanged(gameData);
        } else {
          throw ("Snapshot does not exist");
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("An error ocurred starting a game: $e");
      }
      rethrow;
    }
  }

  // Get items from Firebase
  Future<void> startGame(String gameId, String player1Id) async {
    List<String> gameBoard = List.filled(9, "");
    GameData newGame = GameData(gameId,
        player1Id: player1Id, board: gameBoard, p1IsWinner: null, isTie: false);
    try {
      await _database.child("games/$gameId/gameData").set(newGame.toMap());
      listenToGameChanges(gameId);
    } catch (e) {
      if (kDebugMode) {
        print("An error ocurred starting a game: $e");
      }
      rethrow;
    }
  }

  Future<GameData> retrieveGame(String gameId) async {
    late GameData foundGame;
    try {
      final snapshot = await _database.child("games/$gameId/gameData").get();
      if (snapshot.exists) {
        Map gameMap = snapshot.value as Map;
        foundGame = GameData.fromMap(gameMap);
      } else {
        throw ("Game with id '$gameId' not found");
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error ocurred retrieving a game: $e");
      }
      rethrow;
    }
    return foundGame;
  }

  Future<void> updateGame(GameData newGameData) async {
    try {
      await _database
          .child("games/${newGameData.gameId}/gameData")
          .set(newGameData.toMap());
    } catch (e) {
      if (kDebugMode) {
        print("An error ocurred updating a game: $e");
      }
      rethrow;
    }
  }

  Future<GameData> joinGame(String gameId, String player2Id) async {
    late GameData joinedGame;
    try {
      joinedGame = await retrieveGame(gameId);
      if (joinedGame.player2Id == null) {
        joinedGame.player2Id = player2Id;
        joinedGame.xIsPlaying = true;
        await updateGame(joinedGame);
        listenToGameChanges(joinedGame.gameId);
      } else {
        throw ("The game is already full");
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error ocurred joining a game: $e");
      }
      rethrow;
    }
    return joinedGame;
  }

  Future<void> endGame(String gameId) async {
    await _gameSubscription?.cancel();
    _gameSubscription = null;
    _database.child("games/$gameId").remove();
  }
}
