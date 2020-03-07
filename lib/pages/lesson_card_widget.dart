import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/common_widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/DataUtils.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/widgets/okProgressBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../styles.dart';
import 'lesson_page.dart';

/*********************************************
 *
 * LessonCardWidget
 *
 *********************************************/

class LessonCardWidget extends StatelessWidget {
  /// Veggie to be displayed by the card.
  final LessonDesc desc;
  LessonData data;

  LessonCardWidget(this.desc) {
    data = LessonDataManager.singleton().getLessonData(desc.lessonId);
  }


  @override
  Widget build(BuildContext context) {
    String bgImage = YoutubePlayer.getThumbnail(
        videoId: desc.videoList[0], quality: ThumbnailQuality.standard);

    var card = Container(
        height: 240,
        child: GestureDetector(
          onTap: () {
            /*
            Navigator.of(context).push<void>( CupertinoPageRoute(
                builder: (context) =>  LessonPage( desc : desc, data : data),
                fullscreenDialog: true));

             */

            showCupertinoModalPopup<LessonPage>(
                context: context,
                builder: (context) => LessonPage(desc: desc, data: data));
          },
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      color: Colors.amber,
                      height: 200,
                      width: 600,
                      child: Stack(children: [
                        Container(
                            child: Image.network(bgImage, fit: BoxFit.fitWidth),
                            height: 200,
                            width: 600),
//                      ColorFiltered(
//                        colorFilter: ColorFilter.mode(
//                          Colors.grey,
//                          BlendMode.saturation,
//                        ),
//                        child: Image.network(bgImage, fit: BoxFit.fitWidth),
//                      ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ]))),
              Positioned(
                top: -40,
                right: 5,
                child: SafeArea(
                  child: okSelectableIcon(
                    iconDataOn: Icons.star,
                      iconDataOff: Icons.star_border,
                      initSelected: data.favorited,
                      onChangeState: (bool sel) {
                        data.favorited = sel;
                        // Navigator.of(context).pop();
                      }),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _detailPanel(),
              )
            ],
          ),
        ));

    var padding = Padding(padding: EdgeInsets.all(20), child: card);

    return padding;
  }

  Widget _detailPanel() {
    const double panel_width = 500;

    return Container(
      height: 90,
      width: panel_width,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
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
//        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 5,
                left: 5,
                child: Text(
                  desc.title,
                  style: Styles.courseCardTitleText,
                )),
            Positioned(
                top: 30,
                left: 5,
                child: Text(
                  getLevelName(desc.level),
                  style: Styles.courseCardTitle2Text,
                  textAlign: TextAlign.center,
                )),
            Positioned(
                top: 30,
                left: 110,
                child: Text(
                  "추천",
                  style: Styles.courseCardTitle2Text,
                )),
            Positioned(top: 30, left: 150, child: _starsWidget()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: isPlayingLesson(desc) ?  _progressBar() : _lookAroundButton()
                  ),
            )
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

    var icons = List<Widget>.generate(desc.recommanded, (index) {
      return icon;
    });

    return SizedBox(
        //width: 150,
        //height: 18,
        child: Row(children: icons));
  }

  Widget _lookAroundButton() {
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

  Widget _progressBar() {
    const barSize = 300.0;
    const pointSize = 10.0;

    List<Widget> stage = List<Widget>();
    List<int> progs = getLessonProgress(desc) ;

   // double step = (barSize) / (progs[0]);
    double step = (barSize - (pointSize *  progs[0])) / (progs[0]);

    for (int s = 0; s < progs[0]; s++) {
     // if( i == (progs[0]-1))
      //    step = 0;
      VideoData videoData = LessonDataManager.singleton().getVideoData( desc.videoList[s]);
      Color c = Colors.white;
      if(videoData.completed) c = Colors.green;
      else if(videoData.time > 0) c = Colors.greenAccent;

      Widget point = Padding(
          padding: EdgeInsets.only(left: 0, right: step),
          child: Icon(Icons.brightness_1, size: pointSize, color: c));
      stage.add(point);
    }

    String proText = "${progs[1]} of ${progs[0]} lesson progressed";

    return Container(
        height: 30,
        width: barSize,
        child: Stack(
          children: [
            okStageProgressBar(width: barSize, height: 10, totalStage: progs[0], progStage: progs[1], p: 1/3),
//
//            okProgressBar(width: barSize, height: 10, p: 2.0/3.0),
//            Row(children: stage),
            Positioned(
              left: 0,
              bottom: 5,
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

class LessonCardSimpleWidget extends StatelessWidget {
  final LessonDesc desc;
  final LessonData data;

  LessonCardSimpleWidget(this.desc)
      : data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}

  @override
  Widget build(BuildContext context) {
    var padding = Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: _detailPanel());

    return padding;
  }

  Widget _detailPanel() {
    const double panel_width = 500;

    return Container(
      height: 70,
      width: panel_width,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0, // has the effect of softening the shadow
            spreadRadius: 0.0, // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 5,
                left: 5,
                child: Text(
                  "중급코스",
                  style: Styles.courseCardTitle2Text,
                  textAlign: TextAlign.center,
                )),
            Positioned(
                top: 5,
                left: 110,
                child: Text(
                  "추천",
                  style: Styles.courseCardTitle2Text,
                )),
            Positioned(top: 5, left: 150, child: _starsWidget()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: isPlayingLesson(desc) ?  _progressBar() : _lookAroundButton()
                  ),
            )
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

  Widget _lookAroundButton() {
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

  Widget _progressBar() {
    const barSize = 340.0;
    const pointCount = 5;

    List<Widget> stage = List<Widget>();
    List<int> progs =  getLessonProgress(desc);// desc.getProgressStatus();

    double step = (barSize - (10 *  progs[0])) / (progs[0]);

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
            okStageProgressBar(width: barSize, height: 10, totalStage: progs[0], progStage: progs[1], p: 1/3),
           //Row(children: stage),
            Positioned(
              left: 0,
              bottom: 5,
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
