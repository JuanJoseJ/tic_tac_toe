import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/game_dialogs.dart';
import 'package:tic_tac_toe/game/game_board.dart';
import 'package:tic_tac_toe/game/game_control.dart';
import 'package:tic_tac_toe/game/game_drawer.dart';
import 'package:tic_tac_toe/game/game_util.dart';
import 'package:tic_tac_toe/realtime_db_service.dart';

class MultiplayerGameLayout extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final RealtimeDBSerice rtdbs;
  const MultiplayerGameLayout(
      {super.key, required this.navigator, required this.rtdbs});

  @override
  State<MultiplayerGameLayout> createState() => _MultiplayerGameLayoutState();
}

class _MultiplayerGameLayoutState extends State<MultiplayerGameLayout> {
  List<String> board = List.filled(9, "", growable: false);
  List<String> newBoard = List.filled(9, "", growable: false);
  bool xTurn = true;
  bool isWin = false;
  bool isTie = false;

  /// CHENGE THIS LATER
  String gameId = "g1";

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Close game on any type of pop of the widget
        widget.rtdbs.endGame(gameId);
        return true; // Return true to allow the pop (dismissal of the dialog)
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        drawer: GameDrawer(rtdbs: widget.rtdbs, gameId: gameId),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 50,
            //   child: Text("MULTI PLAYER GAME"),
            // ),
            GameBoard(
              board: board,
              newBoard: newBoard,
              isTie: isTie,
              isWin: isWin,
              xTurn: xTurn,
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
      ),
    );
  }
}
