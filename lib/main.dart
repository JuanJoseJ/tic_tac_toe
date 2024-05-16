import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/local_game_layout.dart';
import 'package:tic_tac_toe/game/multiplayer_game_layout.dart';
import 'package:tic_tac_toe/landing/landing_layout.dart';
import 'package:tic_tac_toe/realtime_db_service.dart';
import 'package:tic_tac_toe/user/logIn_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/util/game_data_class.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RealtimeDBSerice rtdbs = RealtimeDBSerice((GameData gameData) {
    print("GameData updated --> Player Id is: ${gameData.player1Id}");
  });
  await rtdbs.startGame("g1", "p1");
  // rtdbs.listenToGameChanges("g1");
  await rtdbs.updateGame(GameData("g1", "new p1"));


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      navigatorKey: mainNavigatorKey,
      initialRoute: '/logIn',
      routes: <String, WidgetBuilder>{
        "/logIn": (context) => LoginLayout(
              navigator: mainNavigatorKey,
            ),
        "/landing": (context) => LandingLayout(
              navigator: mainNavigatorKey,
            ),
        "/localGame": (context) => GameLayout(
              navigator: mainNavigatorKey,
            ),
        "/multiplayerGame": (context) => MultiplayerGameLayout(
              navigator: mainNavigatorKey,
            ),
      },
    );
  }
}
