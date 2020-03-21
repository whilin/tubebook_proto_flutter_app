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

class okStageProgressBar extends StatelessWidget {
  final int totalStage;
  final int progStage;

  final double width;
  final double height;
  final double p;

  okStageProgressBar({this.width, this.height, this.totalStage, this.progStage, this.p});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _progressBar();
  }

  Widget _progressBar() {
   // const barSize = 300.0;
    var pointSize = height;

    List<Widget> stage = List<Widget>();
   // List<int> progs = getLessonProgress(desc) ;

    // double step = (barSize) / (progs[0]);
    double step = (width - (pointSize *  totalStage)) / totalStage;

    for (int s = 0; s < totalStage; s++) {

      Color c = s < progStage ? Colors.greenAccent : Colors.white;

      Widget point = Padding(
          padding: EdgeInsets.only(left: 0, right: step),
          child: Icon(Icons.brightness_1, size: pointSize, color: c));
      stage.add(point);
    }

    return Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            okProgressBar(width: width, height: height, p: p),
            Row(children: stage),
          ],
        ));
  }
}