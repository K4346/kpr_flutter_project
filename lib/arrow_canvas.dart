import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpr_flutter_project/utils.dart';

class ArrowPainter extends CustomPainter {
  final double currentAmount;
  final double previousAmount;

  ArrowPainter({
    required this.currentAmount,
    required this.previousAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    ArrowData arrowData = prepareAxesAndAmountForArrow();
    final p1 = arrowData.p1;
    final p2 = arrowData.p2;

    canvas.drawLine(p1, p2, paint);

    final dX = p2.dx - p1.dx;
    final dY = p2.dy - p1.dy;
    final angle = atan2(dY, dX);

    final arrowSize = 15;
    final arrowAngle = 25 * pi / 180;

    final path = Path();

    path.moveTo(p2.dx - arrowSize * cos(angle - arrowAngle),
        p2.dy - arrowSize * sin(angle - arrowAngle));
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p2.dx - arrowSize * cos(angle + arrowAngle),
        p2.dy - arrowSize * sin(angle + arrowAngle));
    path.close();
    canvas.drawPath(path, paint);

    drawText(p1, p2, arrowData.text, canvas, size);
  }

  ArrowData prepareAxesAndAmountForArrow() {
    String text = "";
    double fromX = 20, fromY = 20, toX = 75, toY;
    String amount = Utils()
        .formatDoubleToDisplayingAmount(currentAmount - previousAmount, 3);
    if (previousAmount == currentAmount) {
      toY = 20;
      text = 'Не изменилось';
    } else if (previousAmount < currentAmount) {
      fromY = 70;
      toY = 20;
      text = '+$amount₽';
    } else {
      fromY = 20;
      toY = 70;
      text = '$amount₽';
    }
    return ArrowData(
        p1: Offset(fromX, fromY), p2: Offset(toX, toY), text: text);
  }

  void drawText(Offset p1, Offset p2, String text, Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
    TextSpan textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(p2.dx, (p2.dy + p1.dy) / 2.5);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => false;
}

class ArrowData {
  final Offset p1;
  final Offset p2;
  final String text;

  ArrowData({required this.p1, required this.p2, required this.text});
}
