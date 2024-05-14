import 'package:flutter/material.dart';

class DraggableSymbol extends StatelessWidget {
  final String type;
  final CustomPainter painter;
  final bool enabled;
  const DraggableSymbol(
      {Key? key,
      required this.type,
      required this.painter,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return enabled
        ? Draggable<String>(
            data: type,
            feedback: SizedBox(
                width: 50, height: 50, child: CustomPaint(painter: painter)),
            childWhenDragging: Container(
              width: 50,
              height: 50,
              color: Colors.grey.withAlpha(50),
            ),
            child: SizedBox(
              width: 50,
              height: 50,
              child: CustomPaint(
                painter: painter,
              ),
            ),
          )
        : CustomPaint(painter: painter);
  }
}
