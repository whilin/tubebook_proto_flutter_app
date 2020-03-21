import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterActionButton extends StatefulWidget {
  static const Color _beginColor = Colors.pink;
  static const Color _endColor = Colors.pinkAccent; // Colors.pink[800];

  final Color beginColor;
  final Color endColor;

  //final VoidCallback onClick;
  final void Function(int) onSelected;

  const FilterActionButton(
      {Key key,
      this.onSelected,
      this.beginColor = _beginColor,
      this.endColor = _endColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilterActionButtonState();
  }
}

class _FilterActionButtonState extends State<FilterActionButton>
    with SingleTickerProviderStateMixin {
  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation =
        new ColorTween(begin: widget.beginColor, end: widget.endColor)
            .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new SizedBox(
              width: expandedSize,
              height: expandedSize,
              child: new Stack(alignment: Alignment.center, children: [
                _buildExpandedBackground(),
                _buildOption(0, Icons.favorite, 0),
                _buildOption(1, Icons.check_circle, -pi / 3),
                _buildOption(2, Icons.play_circle_filled, -pi * 2 / 3),
                _buildOption(3, Icons.new_releases, -pi),
                _buildFabCore()
              ]));
        });
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();

    return new FloatingActionButton(
      onPressed: _onFabTap,
      child: new Transform(
          alignment: Alignment.center,
          transform: new Matrix4.identity()..scale(1.0, scaleFactor),
          child: new Icon(_animationController.value > 0.5
              ? Icons.close
              : Icons.filter_list)),
      backgroundColor: _colorAnimation.value,
    );
  }

  Widget _buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: widget.beginColor),
    );
  }

  void open() {
    if (_animationController.isDismissed) _animationController.forward();
  }

  void close() {
    if (_animationController.isCompleted) _animationController.reverse();
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  Widget _buildOption(int index, IconData icon, double angle) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }

    return new Transform.rotate(
        angle: angle,
        child: new Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: new EdgeInsets.only(top: 8.0),
                child: new IconButton(
                  onPressed: () {
                    close();
                    widget.onSelected(index);
                  },
                  icon: new Transform.rotate(
                      angle: -angle,
                      child: new Icon(icon, color: Colors.white)),
                  iconSize: iconSize,
                  alignment: Alignment.center,
                  padding: new EdgeInsets.all(0.0),
                ))));
  }
}
