import 'package:flutter/material.dart';
import 'CirclePainter.dart';
import 'package:kpr_flutter_project/const/PageConst.dart';

class CirclePage extends StatefulWidget {
  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<CirclePage> {
  double _len = 0.0;
  double _x = 0.0;
  double _y = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PageConst.CIRCLE_PAGE),
      ),
      body: Container(
          child: Center(
              child: GestureDetector(
        onHorizontalDragStart: (detail) {
          _x = detail.globalPosition.dx;
        },
        onVerticalDragStart: (detail) {
          _y = detail.globalPosition.dy;
        },
        onHorizontalDragUpdate: (detail) {
          setState(() {
            _len -= detail.globalPosition.dx - _x;
            _x = detail.globalPosition.dx;
          });
        },
        onVerticalDragUpdate: (detail) {
          setState(() {
            _len += detail.globalPosition.dy - _y;
            _y = detail.globalPosition.dy;
          });
        },
        child: Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: CirclePainter(startAngle: _len),
            child: Container(),
          ),
        ),
      ))),
    );
  }
}
