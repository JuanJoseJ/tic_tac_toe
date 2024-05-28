import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/draggable_object.dart';
import 'package:tic_tac_toe/game/drawings.dart';

class GameBoard extends StatelessWidget {
  final List<String> board;
  final List<String> newBoard;
  final bool isTie;
  final bool isWin;
  final Function makeMove;
  const GameBoard({
    super.key,
    required this.board,
    required this.newBoard,
    required this.isTie,
    required this.isWin,
    required this.makeMove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: 9,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _draggableTile(index);
        });
  }

  DragTarget<String> _draggableTile(int index) {
    return DragTarget<String>(
      onWillAccept: (data) => (newBoard[index] == '' && !isWin && !isTie),
      onAccept: (data) {
        makeMove(index, data);
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
