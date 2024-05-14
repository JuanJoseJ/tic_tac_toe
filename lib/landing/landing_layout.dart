import 'package:flutter/material.dart';

class LandingLayout extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  const LandingLayout({super.key, required this.navigator});

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
              onPressed: () {
                Navigator.pushNamed(context, "/onlineGame");
              },
              child: const Text("Start Online Game")),
        ],
      ),
    ));
  }
}
