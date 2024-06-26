import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/game_dialogs.dart';
import 'package:tic_tac_toe/game/game_board.dart';
import 'package:tic_tac_toe/game/game_control.dart';
import 'package:tic_tac_toe/game/game_drawer.dart';
import 'package:tic_tac_toe/game/game_util.dart';

class GameLayout extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  const GameLayout({super.key, required this.navigator});

  @override
  State<GameLayout> createState() => _GameLayoutState();
}

class _GameLayoutState extends State<GameLayout> {
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

  passTurn() async {
    if (listEquals(board, newBoard)) {
    } else {
      setState(() {
        board = [...newBoard];
        xTurn = !xTurn;
      });
    }
    if (checkWin(board)) {
      setState(() {
        isWin = true;
      });
    }
    if (checkTie(board, isWin)) {
      setState(() {
        isTie = true;
      });
    }
    if (isTie || isWin) {
      await showEndDialog(context, isWin, xTurn, isTie);
      resetBoard();
    }
  }

  makeMove(int index, String data) {
    setState(() {
      newBoard = [...board];
      newBoard[index] = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      drawer: const GameDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 50,
            child: !xTurn
                ? gameControlls(xTurn, passTurn, resetBoard)
                : const SizedBox(),
          ),
          GameBoard(
            board: board,
            newBoard: newBoard,
            isTie: isTie,
            isWin: isWin,
            makeMove: makeMove,
          ),
          SizedBox(
            height: 50,
            child: xTurn
                ? gameControlls(xTurn, passTurn, resetBoard)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
