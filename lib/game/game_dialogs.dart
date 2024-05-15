  import 'package:flutter/material.dart';

Future<void> showEndDialog(BuildContext context, bool isWin, bool xTurn, bool isTie) {
    return showDialog(
        context: context,
        builder: (BuildContext conext) {
          late Widget title;
          if (isWin) {
            title = Text("${!xTurn ? 'X' : 'O'} won!");
          } else if (isTie) {
            title = const Text("Its a tie!");
          } else {
            throw ("Game ended unexpectedly!");
          }
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title,
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('Play Again'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }