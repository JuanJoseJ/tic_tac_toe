import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/main_provider.dart';
import 'package:tic_tac_toe/services/realtime_db_service.dart';

class GameDrawer extends StatelessWidget {
  final RealtimeDBSerice? rtdbs;
  final String? gameId;
  const GameDrawer({super.key, this.rtdbs, this.gameId});

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 50),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Landing Page'),
            onTap: () {
              if (rtdbs != null && gameId != null) {
                rtdbs!.endGame(gameId!);
              }
              mainProvider.setGameId(null);
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
              if (rtdbs != null && gameId != null) {
                rtdbs!.endGame(gameId!);
              }
              mainProvider.setGameId(null);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/logIn',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
