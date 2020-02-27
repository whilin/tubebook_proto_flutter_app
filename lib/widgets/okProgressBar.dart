import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class okProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final double p;

  okProgressBar({this.width, this.height, this.p});

  @override
  State<okProgressBar> createState() {
    // TODO: implement createState
    return okProgressBarState();
  }
}

class okProgressBarState extends State<okProgressBar> {
  @override
  Widget build(BuildContext context) {

    var percent = min(widget.p, 1);

    return Container(

        child: Stack(children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height * 0.5),
              color: Colors.black26,
            ),
          ),
          Container(
              width: (widget.width * percent),
              height: widget.height,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height * 0.5),
                color: Colors.yellow,
              ))
        ]));
  }
}
