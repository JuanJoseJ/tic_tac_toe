import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/draggable_object.dart';
import 'package:tic_tac_toe/game/drawings.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<String> board = List.filled(9, "", growable: false);
  List<String> newBoard = List.filled(9, "", growable: false);
  bool xTurn = true;
  bool isWin = false;
  bool isTie = false;

  resetBoard() {
    setState(() {
      board = List.filled(9, "", growable: false);
      newBoard = List.filled(9, "", growable: false);
      xTurn = true;
      isWin = false;
      isTie = false;
    });
  }

  passTurn() {
    if (listEquals(board, newBoard)) {
    } else {
      setState(() {
        board = [...newBoard];
        xTurn = !xTurn;
      });
    }
    if (checkWin()) {
      setState(() {
        isWin = true;
      });
    }
    if (checkTie()) {
      setState(() {
        isTie = true;
      });
    }
    if (isTie || isWin) {
      _showEndDialog(context);
    }
  }

  bool checkWin() {
    for (int i = 0; i < 3; i += 1) {
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        if (board[i * 3] != "") return true;
      }
    }

    for (int i = 0; i < 3; i += 1) {
      if (board[i] == board[i + 3] && board[i] == board[i + 6]) {
        if (board[i] != "") return true;
      }
    }

    if ((board[0] == board[4] && board[0] == board[8]) ||
        (board[2] == board[4] && board[2] == board[6])) {
      if (board[4] != "") return true;
    }
    return false;
  }

  bool checkTie() {
    if (board.any((element) => element == "" && !isWin)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 50,
          child: !xTurn ? _gameControlls() : SizedBox(),
        ),
        GridView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: 9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _draggableTile(index);
            }),
        SizedBox(
          height: 50,
          child: xTurn ? _gameControlls() : SizedBox(),
        ),
      ],
    );
  }

  Row _gameControlls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Container(
            child: (listEquals(newBoard, board) && !isWin && !isTie)
                ? DraggableSymbol(
                    type: xTurn ? 'X' : "O",
                    painter: xTurn ? CrossPainter() : CirclePainter(),
                    enabled: true,
                  )
                : null,
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

  DragTarget<String> _draggableTile(int index) {
    return DragTarget<String>(
      onWillAccept: (data) => (newBoard[index] == '' && !isWin && !isTie),
      onAccept: (data) {
        setState(() {
          newBoard = [...board];
          newBoard[index] = data;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.amber,
          ),
          child: newBoard[index] == 'X'
              ? DraggableSymbol(
                  type: 'X',
                  painter: CrossPainter(),
                  enabled: board[index] != newBoard[index],
                )
              : newBoard[index] == "O"
                  ? DraggableSymbol(
                      type: 'O',
                      painter: CirclePainter(),
                      enabled: board[index] != newBoard[index],
                    )
                  : null,
        );
      },
    );
  }

  Future<void> _showEndDialog(BuildContext context) {
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
                      resetBoard();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
