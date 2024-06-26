import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/services/realtime_db_service.dart';

Future<void> startGameDialog(
    BuildContext context, String gameId, RealtimeDBSerice rtdbs) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          rtdbs.endGame(gameId);
          return true; // Return true to allow the pop (dismissal of the dialog)
        },
        child: AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This is your game id:"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(gameId),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Waiting for p2 to join..."),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    rtdbs.endGame(gameId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> joinGameDialog(BuildContext context) async {
  TextEditingController textController = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Input game Id: "),
          ],
        ),
        content: TextField(
          controller: textController,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Join'),
                onPressed: () {
                  Navigator.of(context).pop(textController.text);
                },
              ),
            ],
          )
        ],
      );
    },
  );
}

// ignore: prefer_void_to_null
FutureOr<Null> errorGameDialog(BuildContext context, Object? error) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("$error"),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
