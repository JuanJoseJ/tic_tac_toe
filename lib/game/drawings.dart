import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawCircle(size.center(Offset.zero), size.width * 0.4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawLine(
        Offset(10, 10), Offset(size.width - 10, size.height - 10), paint);
    canvas.drawLine(
        Offset(size.width - 10, 10), Offset(10, size.height - 10), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
