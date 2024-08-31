import 'dart:math';
import 'package:flutter/material.dart';

class SpeedometerPainter extends CustomPainter {
  final double speed;

  SpeedometerPainter(this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    // Define constants
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY);

    // Define colors and paint
    final rimPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final progressPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.blue, Colors.lightBlue],
      ).createShader(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final centerCirclePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw the rim of the speedometer
    canvas.drawCircle(Offset(centerX, centerY), radius, rimPaint);

    // Draw the progress arc based on speed
    double sweepAngle =
        min(speed / 220 * 180, 180); // Assuming speed ranges from 0 to 220
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      pi,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw a small circle at the center
    canvas.drawCircle(Offset(centerX, centerY), 15, centerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
