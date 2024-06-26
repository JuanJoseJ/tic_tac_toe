import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/main_provider.dart';
import 'package:tic_tac_toe/game/local_game_layout.dart';
import 'package:tic_tac_toe/game/multiplayer_game_layout.dart';
import 'package:tic_tac_toe/landing/landing_layout.dart';
import 'package:tic_tac_toe/services/realtime_db_service.dart';
import 'package:tic_tac_toe/user/login_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/util/game_data_class.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          MainProvider(), // Replace Counter with your model if different
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();
  final RealtimeDBSerice rtdbs = RealtimeDBSerice((GameData gd) {});

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
              rtdbs: rtdbs,
            ),
        "/localGame": (context) => GameLayout(
              navigator: mainNavigatorKey,
            ),
        "/multiplayerGame": (context) => MultiplayerGameLayout(
              navigator: mainNavigatorKey,
              rtdbs: rtdbs,
            ),
      },
    );
  }
}
