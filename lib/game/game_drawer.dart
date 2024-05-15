import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameDrawer extends StatelessWidget {
  const GameDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
