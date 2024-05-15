import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/draggable_object.dart';
import 'package:tic_tac_toe/game/drawings.dart';

Widget gameControlls(bool xTurn, Function passTurn, Function resetBoard) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        height: 50,
        width: 50,
        child: DraggableSymbol(
          type: xTurn ? 'X' : "O",
          painter: xTurn ? CrossPainter() : CirclePainter(),
          enabled: true,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              passTurn();
            },
            child: RotatedBox(
                quarterTurns: xTurn ? 0 : 2,
                child: const Text(
                  "End Turn",
                )),
          ),
          RotatedBox(
            quarterTurns: xTurn ? 0 : 2,
            child: IconButton(
              onPressed: () {
                resetBoard();
              },
              icon: const Icon(Icons.restart_alt_rounded),
            ),
          ),
        ],
      ),
    ],
  );
}
