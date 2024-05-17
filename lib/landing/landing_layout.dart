import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/landing/landing_dialogs.dart';
import 'package:tic_tac_toe/realtime_db_service.dart';
import 'package:tic_tac_toe/util/game_data_class.dart';

class LandingLayout extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  final RealtimeDBSerice rtdbs;
  const LandingLayout(
      {super.key, required this.navigator, required this.rtdbs});

  startGameProtocol(BuildContext context) {
    String gameId = "g1";
    String playerId = "p1";
    try {
      rtdbs.startGame(gameId, playerId);
    } catch (e) {
      if (kDebugMode) {
        print("An error ocurred at the startGameProtocol: $e");
      }
      rethrow;
    }
    return startGameDialog(context, gameId, rtdbs);
  }

  Future<void> joinGameProtocol(BuildContext context) async {
    late String? gameId;
    String playerId = "p2";
    gameId = await joinGameDialog(context);
    if (gameId != null && gameId.isNotEmpty) {
      try {
        await rtdbs.joinGame(gameId, playerId);
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Landing"),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/logIn",
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Go to LogIn")),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/localGame");
              },
              child: const Text("Start Local Game")),
          ElevatedButton(

              /// When a player wants to start a game, he must wait for another player to join
              /// using the id of the game he created. Then the game start normally.
              onPressed: () {
                rtdbs.onGameChanged = (GameData gd) {
                  if (gd.player2Id != null) {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, "/multiplayerGame");
                  }
                };
                startGameProtocol(context);
              },
              child: const Text("Start Online Game")),
          ElevatedButton(

              /// When a player wants to join a game, he must first indicate the game id provided by
              /// a first player OOB, Then the game starts normally.
              onPressed: () async {
                await joinGameProtocol(context).onError((error, stackTrace) {
                  return errorGameDialog(context, error);
                });
              },
              child: const Text("Join Online Game")),
        ],
      ),
    ));
  }
}
