import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/game_board.dart';

class GameLayout extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  const GameLayout({super.key, required this.navigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Landing Page'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/landing',
                  (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Log In'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/logIn',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: const GameBoard(),
    );
  }
}
