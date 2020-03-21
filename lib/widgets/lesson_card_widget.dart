import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/common_widgets/cardWidgets.dart';
import 'package:mydemo_tabnavi2/common_widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/common_widgets/okProgressBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../styles.dart';
import '../pages/lesson_page.dart';

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

  @override
  Widget build(BuildContext context) {
    String bgImage = YoutubePlayer.getThumbnail(
        videoId: widget.desc.videoList[0], quality: ThumbnailQuality.standard);

    var card = Container(
        width: 400,
        height: 240,
        child: GestureDetector(
          onTap: () {
            /*
            Navigator.of(context).push<void>( CupertinoPageRoute(
                builder: (context) =>  LessonPage( desc : desc, data : data),
                fullscreenDialog: true));

             */
            _showLessonPage();
          },
          child: Stack(
            // overflow: Overflow.visible,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      color: Colors.amber,
                      height: 200,
                      child: Stack(children: [
                        Container(
                            child: Image.network(bgImage, fit: BoxFit.fitWidth),
                            height: toHDHeight(400), //200,
                            width: 400 //toHDWidth(200)),
//                      ColorFiltered(
//                        colorFilter: ColorFilter.mode(
//                          Colors.grey,
//                          BlendMode.saturation,
//                        ),
//                        child: Image.network(bgImage, fit: BoxFit.fitWidth),
                            ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ]))),
              /*
              Positioned(
                top: -40,
                right: 5,
                child: SafeArea(
                  child: okSelectableIcon(
                      iconDataOn: Icons.favorite,
                      iconDataOff: Icons.favorite_border,
                      initSelected: widget.data.favorited,
                      onChangeState: (bool sel) {
                        widget.data.favorited = sel;
                        // Navigator.of(context).pop();
                      }),
                ),
              ),
               */
              Positioned(
                top: 0,
                left: 10,
                child: Row(
                  children: _chips(),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 15,
                right: 15,
                child: LessonCardDetailBarWidget.forTopic(
                    desc: widget.desc,
                    onBarClick: () {},
                    onSubscribeClick: () {}), //_detailPanel(),
              )
            ],
          ),
        ));

    var padding = Padding(padding: EdgeInsets.all(10), child: card);
    var scaleAni = ScaleTransition(
      scale: animation,
      child: padding,
    );

    var moveAni = Transform.translate(
        offset: Offset(0, (1 - animation.value) * 600), child: padding);

    return moveAni;
  }

  void _showLessonPage() {

    showCupertinoModalPopup<LessonPage>(
        context: context,
        builder: (context) =>
            LessonPage(desc: widget.desc, data: widget.data));
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

enum _DetailBarType {
  forTopic,
  forLesson,
  forMyClass,
}

class LessonCardDetailBarWidget extends StatelessWidget {
  final LessonDesc desc;
  final LessonData data;
  final _DetailBarType _type;
  final void Function() onBarClick;
  final void Function() onSubscribeClick;

  LessonCardDetailBarWidget.forTopic(
      {this.desc, this.onBarClick, this.onSubscribeClick})
      : _type = _DetailBarType.forTopic,
        data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}

  LessonCardDetailBarWidget.forLesson(
      {this.desc, this.onBarClick, this.onSubscribeClick})
      : _type = _DetailBarType.forLesson,
        data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}

  LessonCardDetailBarWidget.forMyClass(
      {this.desc, this.onBarClick, this.onSubscribeClick})
      : _type = _DetailBarType.forMyClass,
        data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}

  @override
  Widget build(BuildContext context) {
//    var padding = Padding(
//        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
//        child: _detailPanel(context));

    final panel = _detailPanel(context);

    final click = GestureDetector(
      child: panel,
      onTap: () {
        onBarClick();
      },
    );

    return click;
  }

  Widget _detailPanel(BuildContext context) {
    const double panel_width = 300;

    final TopicDesc topicDesc =
        LessonDescManager.singleton().getTopic(desc.mainTopicId);

    return Container(
      height: 90,
      width: panel_width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
//        boxShadow: [
//          BoxShadow(
//            color: Colors.black,
//            blurRadius: 2.0, // has the effect of softening the shadow
//            spreadRadius: 0.0, // has the effect of extending the shadow
//            offset: Offset(
//              1.0, // horizontal, move right 10
//              2.0, // vertical, move down 10
//            ),
//          )
        //       ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: okSelectableIcon(
                  iconDataOn: Icons.favorite,
                  iconDataOff: Icons.favorite_border,
                  initSelected: data.favorited,
                  onChangeState: (bool sel) {
                    data.favorited = sel;
                    // Navigator.of(context).pop();
                  }),
            ),
            Positioned(
                top: 5,
                left: 5,
                child: Text(
                  desc.title,
                  style: Styles.courseCardTitleText,
                )),
            Positioned(
                top: 32,
                left: 5,
                child: Text(
                  '난이도',
                  style: Styles.courseCardTitle2Text,
                  textAlign: TextAlign.center,
                )),
            Positioned(
                top: 30,
                left: 45,
                child: Text(
                  getLevelName(desc.level),
                  style: Styles.courseCardTitle3Text,
                  textAlign: TextAlign.center,
                )),
            Positioned(
                top: 32,
                left: 125,
                child: Text(
                  "추천",
                  style: Styles.courseCardTitle2Text,
                )),
            Positioned(top: 31, left: 150, child: _starsWidget()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: isPlayingLesson(desc)
                      ? _progressBar(context)
                      : _getNonProgressButton(context)),
            ),
            _type == _DetailBarType.forMyClass
                ? Positioned(
                    top: -25,
                    right: -10,
                    child: new okCircleImage.image(
                        size: 50,
                        imagePath: getImageAssetFile(topicDesc.imageAssetPath)))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _starsWidget() {
    Widget icon = Padding(
        padding: EdgeInsets.only(right: 0, left: 4),
        child: Icon(
          Icons.star,
          size: 18,
          color: Colors.greenAccent,
        ));

    var icons = List<Widget>.generate(2, (index) {
      return icon;
    });

    return SizedBox(
        //width: 150,
        //height: 18,
        child: Row(children: icons));
  }

  Widget _getNonProgressButton(BuildContext context) {
    if (_type == _DetailBarType.forTopic)
      return _lookAroundButton(context);
    else if (_type == _DetailBarType.forLesson)
      return _buildSubscribeButton(context);
    else
      return _lookAroundButton(context);
  }

  Widget _lookAroundButton(BuildContext context) {
    return Container(
        height: 30,
        width: 275,
        // color: Color(0xff0093E8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff64B6FF), Color(0xff374ABE)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Align(
          alignment: Alignment.center,
          child: Text("강의 둘러보기", style: Styles.courseCardTitle2Text),
        ));
  }

  Widget _buildSubscribeButton(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 30,
          width: 275,
          // color: Color(0xff0093E8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff64B6FF), Color(0xff374ABE)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Align(
            alignment: Alignment.center,
            child: Text("레슨 등록하기", style: Styles.courseCardTitle2Text),
          )),
      onTap: () {
       // showMessage(context, "레슨 등록하기");
        onSubscribeClick();
      },
    );
  }

  void showMessage(BuildContext context, String msg) {
    final snackbar = SnackBar(content: Text(msg));

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  Widget _progressBar(BuildContext context) {
    var barSize = MediaQuery.of(context).size.width - 80;

    List<Widget> stage = List<Widget>();
    List<int> progs = getLessonProgress(desc); // desc.getProgressStatus();

    double step = (barSize - (10 * progs[0])) / (progs[0]);

    for (int i = 0; i < progs[0]; i++) {
      // if( i == (progs[0]-1))
      // / step = 0;

      Widget point = Padding(
          padding: EdgeInsets.only(left: 0, right: step),
          child: Icon(Icons.brightness_1, size: 10, color: Colors.white));
      stage.add(point);
    }

    String proText = "${progs[1]} of ${progs[0]} lesson progressed";

    return Container(
        height: 30,
        width: barSize,
        child: Stack(
          children: [
            //  okProgressBar(width: barSize, height: 10, p: 0.75),
            okStageProgressBar(
                width: barSize,
                height: 10,
                totalStage: progs[0],
                progStage: progs[1],
                p: 1 / 3),
            //Row(children: stage),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                proText,
                style: Styles.font10GrayText,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ));
  }
}
