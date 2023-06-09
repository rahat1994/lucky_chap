import 'dart:math';

import 'package:flutter/material.dart';

import 'arrow_view.dart';
import 'model.dart';

class BoardView extends StatefulWidget {
  final double angle;
  final double current;
  final List<Luck> items;

  const BoardView({required Key key, required this.angle, required this.current, required this.items})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BoardViewState();
  }
}

class _BoardViewState extends State<BoardView> {
  Size get size => Size(MediaQuery.of(context).size.width * 0.8,
      MediaQuery.of(context).size.width * 0.8);

  double _rotote(int index) => (index / widget.items.length) * 2 * pi;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //shadow
        Container(
          height: size.height - 10,
          width: size.width - 10,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black38)]),
        ),
        Container(
          height: size.height + 15,
          width: size.width + 15,
          decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black38)]),
        ),

        Container(
          child: Transform.rotate(
            angle: -(widget.current + widget.angle) * 2 * pi,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                for (var luck in widget.items) ...[_buildCard(luck)],
                for (var luck in widget.items) ...[_buildImage(luck)],
              ],
            ),
          ),
        ),
        Container(
          height: size.height,
          width: size.width,
          child: ArrowView(),
        ),

      ],
    );
  }

  _buildCard(Luck luck) {
    var rotate = _rotote(widget.items.indexOf(luck));
    var angle = 2 * pi / widget.items.length;
    return Transform.rotate(
      angle: rotate,
      child: ClipPath(
        clipper: _LuckPath(angle),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [luck.color, luck.color.withOpacity(0)])),
        ),
      ),
    );
  }

  _buildImage(Luck luck) {
    var rotate = _rotote(widget.items.indexOf(luck));
    return Transform.rotate(
      angle: rotate,
      child: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.topCenter,
        child: Text(luck.name),
      ),
    );
  }
}

class _LuckPath extends CustomClipper<Path> {
  final double angle;

  _LuckPath(this.angle);

  @override
  Path getClip(Size size) {
    Path _path = Path();
    Offset _center = size.center(Offset.zero);
    Rect _rect = Rect.fromCircle(center: _center, radius: size.width / 2);
    _path.moveTo(_center.dx, _center.dy);
    _path.arcTo(_rect, -pi / 2 - angle / 2, angle, false);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(_LuckPath oldClipper) {
    return angle != oldClipper.angle;
  }
}