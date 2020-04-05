import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class okProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final double p;

  okProgressBar({this.width, this.height, this.p});

  @override
  State<okProgressBar> createState() {
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
          color: Colors.white,
        ),
      ),
      Container(
          width: (widget.width * percent),
          height: widget.height,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height * 0.5),
              //color: Styles.progBar0,
              gradient:
                  LinearGradient(colors: [Styles.progBar1, Styles.progBar0])))
    ]));
  }
}


class okStageProgressBar extends StatelessWidget {
  final int totalStage;
  final int progStage;

  final double width;
  final double height;
  final double p;

  okStageProgressBar(
      {this.width, this.height, this.totalStage, this.progStage, this.p});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _progressBar(context);
  }

  Widget _progressBar(BuildContext context) {

    var pointSize = height;
    var dotWidth = width;

    List<Widget> stage = List<Widget>();
    double pad = (dotWidth - (pointSize * (totalStage))) / totalStage;

    for (int s = 0; s < totalStage; s++) {

      Color c = s < progStage ? Colors.greenAccent : Colors.black38;
    //  double pad2 = (s == (totalStage - 1)) ? 0 : pad;

      Widget point = Padding(
          padding: EdgeInsets.only(left: 0, right: pad),
          child: Icon(Icons.brightness_1, size: pointSize, color: c));

      stage.add(point);
    }

    return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            okProgressBar(width: width, height: height, p: p),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: stage),
          ],
        ));
  }
}
