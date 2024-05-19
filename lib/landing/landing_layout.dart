import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_tac_toe/landing/landing_dialogs.dart';
import 'package:tic_tac_toe/services/auth_service.dart';
import 'package:tic_tac_toe/services/realtime_db_service.dart';
import 'package:tic_tac_toe/util/game_data_class.dart';
import 'package:tic_tac_toe/util/id_generator.dart';

class LandingLayout extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  final RealtimeDBSerice rtdbs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LandingLayout({super.key, required this.navigator, required this.rtdbs});

  // Function to start a game and handle any errors
  void startGameProtocol(BuildContext context) {
    String gameId = generateGameId();
    String playerId = _auth.currentUser!.uid;
    try {
      rtdbs.startGame(gameId, playerId);
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred at the startGameProtocol: $e");
      }
      rethrow;
    }
    // Show dialog to inform the user about the game ID
    startGameDialog(context, gameId, rtdbs);
  }

  // Function to join a game and handle any errors
  Future<void> joinGameProtocol(BuildContext context) async {
    late String? gameId;
    String playerId = _auth.currentUser!.uid;
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
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // If the user is not logged in, navigate to the login page.
            // WidgetsBinding is used to ensure that navigation to the login page,
            // triggered by the absence of a user, occurs only after the current frame
            // has been fully built. This prevents errors that can occur from attempting
            // navigation during the build process.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/logIn',
                (Route<dynamic> route) => false,
              );
            });
            return Container(); // Returning an empty container temporarily
          } else {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await AuthService().signOut();
                      navigator.currentState?.pushReplacementNamed('/logIn');
                    },
                  )
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Landing"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/localGame");
                      },
                      child: const Text("Start Local Game"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        rtdbs.onGameChanged = (GameData gd) {
                          if (gd.player2Id != null) {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, "/multiplayerGame");
                          }
                        };
                        startGameProtocol(context);
                      },
                      child: const Text("Start Online Game"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await joinGameProtocol(context)
                            .onError((error, stackTrace) {
                          return errorGameDialog(context, error);
                        });
                      },
                      child: const Text("Join Online Game"),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
