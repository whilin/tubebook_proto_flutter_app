import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/net/YoutubeApi.dart';
import 'package:mydemo_tabnavi2/widgets/cardWidgets.dart';
import 'package:mydemo_tabnavi2/widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/widgets/okProgressBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../styles.dart';
import 'lesson_page.dart';
import '../widgets/LessonWidget.dart';

/*********************************************
 *
 * LessonCardWidget
 *
 *********************************************/

class LessonCardWidget extends StatefulWidget {
  /// Veggie to be displayed by the card.
  final LessonDesc desc;
  final LessonData data;
  int listItemIndex;

  LessonCardWidget(this.desc, {this.listItemIndex = 0})
      : data = LessonDataManager.singleton().getLessonData(desc.lessonId);

  @override
  _LessonCardWidgetState createState() => _LessonCardWidgetState();
}

class _LessonCardWidgetState extends State<LessonCardWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double _animationScale = 0;

  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    var animation1 = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          _animationScale = animation.value;
        });
      });
    animation = CurvedAnimation(parent: animation1, curve: Curves.easeOut);

    _animationScale = 0;
    controller.stop();
    delayShow();
  }

  Future<void> delayShow() async {
    int delay = widget.listItemIndex * 300;
    delay = min(3000, delay);
    await Future.delayed(Duration(milliseconds: delay));
    controller.forward();
  }

  @override
  void didUpdateWidget(LessonCardWidget oldWidget) {
    controller.reset();
    delayShow();
    ;
    super.didUpdateWidget(oldWidget);
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showLessonPage() {
    showCupertinoModalPopup<LessonPage>(
        context: context,
        builder: (context) => LessonPage(desc: widget.desc, data: widget.data));
  }


  @override
  Widget build(BuildContext context) {
    String bgImage = YoutubeApi.getThumbnail(
        videoId: widget.desc.videoListEx[0].videoKey, quality: ThumbnailQuality.standard);

    var width = MediaQuery.of(context).size.width - 10;

    var card = ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
            color: Styles.cardColor,
            width: width,
            height: 330,
            child: Stack(children: [
              new Container(
                  child: Image.network(bgImage, fit: BoxFit.fitWidth),
                  height: 100,
                  width: width //toHDWidth(200)),
                  ),
              new Positioned(
                top :5 ,
                  right: 5,
                  child: getLessonLabel()),
              new Positioned(
                  top: 120,
                  left: 20,
                  right: 20,
                  child: LessonWidgets.buildDescriptor(widget.desc)),
              new Positioned(
                  top: 250,
                  left: 20,
                  child: LessonWidgets.buildCreator(widget.desc.youtuberId))
            ])));

    var tap = GestureDetector(
        onTap: () {
          _showLessonPage();
        },
        child: card);

    var padding = Padding(padding: EdgeInsets.all(10), child: tap);
    var scaleAni = ScaleTransition(
      scale: animation,
      child: padding,
    );

    var moveAni = Transform.translate(
        offset: Offset(0, (1 - animation.value) * 600), child: padding);

    return moveAni;
  }


  Widget getLessonLabel() {

    if(widget.data.subscribed) {
      if(getLessonCompleted(widget.desc)) {
        return okBoxText(
          text: '완료',
          style: Styles.font14Text,
          bgColor: Colors.indigoAccent,
        );
      } else {
        return okBoxText(
          text: '진행중',
          style: Styles.font14Text,
          bgColor: Colors.indigoAccent,
        );
      }
    } else {
      return Container();
    }
  }


  List<Widget> _chips() {
    List<Widget> _chips = new List<Widget>();

    _chips.add(Chip(
        label: Text(getLevelName(widget.desc.level)),
        backgroundColor: Colors.lightBlue));
    _chips.addAll(widget.desc.tags
        .map((e) => Chip(
              label: Text(e),
              backgroundColor: Colors.cyanAccent,
            ))
        .toList());

    var list = _chips
        .map((e) =>
            new Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: e))
        .toList();

    return list;
  }
}
