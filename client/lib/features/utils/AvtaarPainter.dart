import 'package:flutter/material.dart';

class AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = const Color(0xFFCCCCE5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Hat
    final hatPaint = Paint()..color = const Color(0xFF6B7AFF);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.2, size.height * 0.3)
        ..lineTo(size.width * 0.8, size.height * 0.3)
        ..lineTo(size.width * 0.5, size.height * 0.1)
        ..close(),
      hatPaint,
    );

    // Face
    final facePaint = Paint()..color = const Color(0xFF855E42);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.3,
      facePaint,
    );

    // Shirt
    final shirtPaint = Paint()..color = const Color(0xFFFF9966);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.65,
        size.width * 0.6,
        size.height * 0.35,
      ),
      shirtPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
