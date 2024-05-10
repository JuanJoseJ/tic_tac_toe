import 'package:flutter/material.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({
    super.key,
  });

  @override
  State<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends State<GameLayout> {
  List<String> board = List.filled(9, "", growable: false);
  bool xTurn = true;
  bool isWinner = false;

  tapBoard(int index) {
    setState(() {
      if (!isWinner) {
        if (board[index] == "") {
          if (xTurn) {
            board[index] = "X";
          } else {
            board[index] = "O";
          }
          if (!checkWin()) {
            xTurn = !xTurn;
          } else {
            isWinner = true;
          }
        }
      }
    });
  }

  resetBoard() {
    setState(() {
      board = List.filled(9, "", growable: false);
      xTurn = true;
      isWinner = false;
    });
  }

  bool checkWin() {
    for (int i = 0; i < 3; i += 1) {
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        if (board[i * 3] != "") return true;
      }
    }

    for (int i = 0; i < 3; i += 1) {
      if (board[i] == board[i + 1] && board[i] == board[i + 2]) {
        if (board[i] != "") return true;
      }
    }

    if ((board[0] == board[4] && board[0] == board[8]) ||
        (board[2] == board[4] && board[2] == board[6])) {
      if (board[4] != "") return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Turn: ${xTurn ? 'X' : 'O'}"),
        Text("Is Winner: $isWinner"),
        Center(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: 9,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      tapBoard(index);
                    },
                    child: Container(
                      child: Center(child: Text(board[index])),
                      color: Colors.amber,
                    ));
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              resetBoard();
            },
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ),
      ],
    );
  }
}
