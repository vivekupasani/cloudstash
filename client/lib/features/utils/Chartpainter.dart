import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue[300]!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.6, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);

    // Draw a dot in the middle
    final dotPaint =
        Paint()
          ..color = Colors.cyan
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.8), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
