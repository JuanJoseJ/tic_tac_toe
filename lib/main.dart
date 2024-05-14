import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/game_layout.dart';
import 'package:tic_tac_toe/landing/landing_layout.dart';
import 'package:tic_tac_toe/user/logIn_layout.dart';

void main() {
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
        "/onlineGame": (context) => GameLayout(
              navigator: mainNavigatorKey,
            ),
      },
    );
  }
}
