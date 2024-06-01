import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/game/game_board.dart';
import 'package:tic_tac_toe/game/game_control.dart';
import 'package:tic_tac_toe/game/game_dialogs.dart';
import 'package:tic_tac_toe/game/game_drawer.dart';
import 'package:tic_tac_toe/main_provider.dart';
import 'package:tic_tac_toe/game/game_util.dart';
import 'package:tic_tac_toe/services/realtime_db_service.dart';
import 'package:tic_tac_toe/util/game_data_class.dart';

class MultiplayerGameLayout extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final RealtimeDBSerice rtdbs;
  const MultiplayerGameLayout(
      {super.key, required this.navigator, required this.rtdbs});

  @override
  State<MultiplayerGameLayout> createState() => _MultiplayerGameLayoutState();
}

class _MultiplayerGameLayoutState extends State<MultiplayerGameLayout> {
  late List<String> board = List.filled(9, "", growable: false);
  List<String> newBoard = List.filled(9, "", growable: false);
  bool xIsPlaying = true;
  bool isWin = false;
  bool isTie = false;
  bool? isLocalTurn;
  bool endDialogShown = false;
  final String localPlayerId = FirebaseAuth.instance.currentUser!.uid;

  resetBoard() {
    setState(() {
      isLocalTurn = null;
      isWin = false;
      isTie = false;
      endDialogShown = false;
    });
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    GameData newGameData = GameData(
      mainProvider.multiPlayerGameId!,
      player1Id: mainProvider.xIsLocalPlayer
          ? localPlayerId
          : mainProvider.adversaryId!,
      player2Id: mainProvider.xIsLocalPlayer
          ? mainProvider.adversaryId!
          : localPlayerId,
    );
    newGameData.board = List.filled(9, "", growable: false);
    newGameData.xIsPlaying = true;
    newGameData.p1IsWinner = null;
    newGameData.isTie = false;

    widget.rtdbs.updateGame(newGameData);
  }

  passTurn() {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    GameData newGameData = GameData(
      mainProvider.multiPlayerGameId!,
      player1Id: mainProvider.xIsLocalPlayer
          ? localPlayerId
          : mainProvider.adversaryId!,
      player2Id: mainProvider.xIsLocalPlayer
          ? mainProvider.adversaryId!
          : localPlayerId,
    );
    if (listEquals(board, newBoard)) {
      /// If board hasnt changed means that the player is missing a movement
      if (kDebugMode) {
        print("Make a move before passing the turn");
      }
    } else {
      newGameData.board = [...newBoard];
      newGameData.xIsPlaying = !xIsPlaying;
      if (checkWin(newBoard)) {
        if (mainProvider.xIsLocalPlayer) {
          newGameData.p1IsWinner = true;
        } else {
          newGameData.p1IsWinner = false;
        }
      }
      if (checkTie(newBoard, newGameData.p1IsWinner != null)) {
        newGameData.isTie = true;
      }
      widget.rtdbs.updateGame(newGameData);
    }
  }

  makeMove(int index, String data) {
    /// Por ahora los movimientos en el juego se ven reflejados solo al pasar del turno.
    /// Más adelante me gustaría que los cambios en el tablero se muestren a los otros jugadores
    /// así no sean los finales.
    setState(() {
      newBoard = [...board];
      newBoard[index] = data;
    });
  }

  endingProtocol(
      BuildContext context, bool isWin, bool xTurn, bool isTie) async {
    print("ENDING PROTOCOL TRIGGERED");
    await showEndDialog(context, isWin, xTurn, isTie);
    resetBoard();
  }

  @override
  initState() {
    super.initState();

    /// Here I can't make any setState because there is no state or context yet
    widget.rtdbs.onGameChanged = (GameData gameData) {
      if (kDebugMode) {
        print("CURRENT GAME DATA: ${gameData.toMap()}");
      }
      setState(() {
        // Set current game
        isLocalTurn =
            (gameData.xIsPlaying && localPlayerId == gameData.player1Id) ||
                (!gameData.xIsPlaying && localPlayerId != gameData.player1Id);
        isTie = gameData.isTie;
        board = [...gameData.board];
        newBoard = [...gameData.board];
        if (gameData.p1IsWinner != null) {
          if ((gameData.p1IsWinner! && localPlayerId == gameData.player1Id) ||
              (!gameData.p1IsWinner! && localPlayerId == gameData.player2Id)) {
            isWin = true;
          }
        }
        if ((isTie || isWin) && !endDialogShown) {
          endDialogShown = true;
          endingProtocol(context, isWin, xIsPlaying, isTie).then((_) {
            endDialogShown = false;
          });
          return;
        }
        xIsPlaying = gameData.xIsPlaying;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    if (isLocalTurn == null) {
      setState(() {
        isLocalTurn = mainProvider.xIsLocalPlayer;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        // Close game on any type of pop of the widget
        widget.rtdbs.endGame(mainProvider.multiPlayerGameId!);
        // Return true to allow the pop (dismissal of the dialog)
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        drawer: mainProvider.multiPlayerGameId != null
            ? GameDrawer(
                rtdbs: widget.rtdbs, gameId: mainProvider.multiPlayerGameId!)
            : null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameBoard(
              board: board,
              newBoard: newBoard,
              isTie: isTie,
              isWin: isWin,
              makeMove: makeMove,
            ),
            SizedBox(
              height: 50,
              child: isLocalTurn != null
                  ? isLocalTurn!
                      ? gameControlls(xIsPlaying, passTurn, resetBoard)
                      : const SizedBox()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
