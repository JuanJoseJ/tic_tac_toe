import 'package:flutter/material.dart';

class LoginLayout extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  const LoginLayout({super.key, required this.navigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login Page"),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, "/landing");
            }, child: const Text("Log In")),
          ],
          ),
      ));
  }
}
