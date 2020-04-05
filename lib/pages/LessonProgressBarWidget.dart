
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/widgets/LessonWidget.dart';
import 'package:mydemo_tabnavi2/widgets/okProgressBar.dart';

import '../styles.dart';

enum _DetailBarType {
  forTopic,
  forLesson,
  forMyClass,
}

class LessonProgressBarWidget extends StatelessWidget {
  final LessonDesc desc;
  final LessonData data;
  final _DetailBarType _type;
  final void Function() onBarClick;
  final void Function() onSubscribeClick;

  LessonProgressBarWidget.forTopic(
      {this.desc, this.onBarClick, this.onSubscribeClick})
      : _type = _DetailBarType.forTopic,
        data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}

  LessonProgressBarWidget.forLesson(
      {this.desc, this.onBarClick, this.onSubscribeClick})
      : _type = _DetailBarType.forLesson,
        data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}

  LessonProgressBarWidget.forMyClass(
      {this.desc, this.onBarClick, this.onSubscribeClick})
      : _type = _DetailBarType.forMyClass,
        data = LessonDataManager.singleton().getLessonData(desc.lessonId) {}
//
//  void showMessage(BuildContext context, String msg) {
//    final snackbar = SnackBar(content: Text(msg), backgroundColor: Colors.blueAccent,);
//
//    Scaffold.of(context)
//      ..removeCurrentSnackBar()
//      ..showSnackBar(snackbar);
//  }

  @override
  Widget build(BuildContext context) {

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
    // const double panel_width = 334;

    final TopicDesc topicDesc =
    LessonDescManager.singleton().getTopic(desc.mainTopicId);

    return Container(
      height: 100,
      // width: panel_width,

      decoration: BoxDecoration(
        // color: _type == _DetailBarType.forMyClass ? Styles.cardColor : Styles.appBackground,
        borderRadius: BorderRadius.circular(10.0),
      ),

      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 5, left : 10, right: 10),
                child : LessonWidgets.buildDescriptorHeader(desc)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: isPlayingLesson(desc)
                      ? _progressBar(context)
                      : _getNonProgressButton(context)),
            ),
          ],
        ),
      ),
    );
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

  Widget _progressBar(BuildContext context) {

    var barSize = MediaQuery.of(context).size.width - 40;

    List<int> progs = getLessonProgress(desc); // desc.getProgressStatus();
    String proText = "${progs[1]} of ${progs[0]} lesson progressed";
    double p = progs[1] / progs[0];

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
                p: p),
            //Row(children: stage),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                proText,
                style: Styles.font12Text,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ));
  }
}
