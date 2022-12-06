import 'dart:math';
import 'dart:ui';

class PieChart {
  void _drawArcWithCenter(
      Canvas canvas,
      Paint paint, {
 required        Offset center,
        required double radius,
        startRadian = 0.0,
        sweepRadian = pi,
      }) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startRadian,
      sweepRadian,
      false,
      paint,
    );
  }
  // void _drawArcTwoPoint(Canvas canvas, Paint paint,
  //     {required Offset center,
  //       required double radius,
  //       startRadian = 0.0,
  //       sweepRadian = pi,
  //       hasStartArc = false,
  //       hasEndArc = false}) {
  //   var smallR = paint.strokeWidth / 2;
  //   paint.strokeWidth = smallR;
  //   if (hasStartArc) {
  //     var startCenter = LineCircle.radianPoint(
  //         Point(center.dx, center.dy), radius, startRadian);
  //     paint.style = PaintingStyle.fill;
  //     canvas.drawCircle(Offset(startCenter.x, startCenter.y), smallR, paint);
  //   }
  //   if (hasEndArc) {
  //     var endCenter = LineCircle.radianPoint(
  //         Point(center.dx, center.dy), radius, startRadian + sweepRadian);
  //     paint.style = PaintingStyle.fill;
  //     canvas.drawCircle(Offset(endCenter.x, endCenter.y), smallR, paint);
  //   }
  // }
  void draw(sources,total){
    List<double> radians = <double>[];
    for (double d in sources) {
      double radian = d * 2 * pi / total;
      radians.add(radian);
    }
  }
}