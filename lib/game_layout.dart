import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/draggable_object.dart';
import 'package:tic_tac_toe/drawings.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({
    super.key,
  });

  @override
  State<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends State<GameLayout> {
  List<String> board = List.filled(9, "", growable: false);
  List<String> newBoard = List.filled(9, "", growable: false);
  bool xTurn = true;
  bool isWinner = false;
  bool isTie = false;

  resetBoard() {
    setState(() {
      board = List.filled(9, "", growable: false);
      newBoard = List.filled(9, "", growable: false);
      xTurn = true;
      isWinner = false;
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
        isWinner = true;
      });
    }
    if(checkTie()){
      setState(() {
        isTie = true;
      });
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

  bool checkTie(){
    if(board.any((element) => element == "")){
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
            child: (listEquals(newBoard, board) && !isWinner && !isTie)
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
      onWillAccept: (data) => (newBoard[index] == '' && !isWinner && !isTie),
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
}
