import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mydemo_tabnavi2/common_widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/course_data_define.dart';
import 'package:mydemo_tabnavi2/datas/course_desc_model.dart';
import 'package:mydemo_tabnavi2/datas/course_play_model.dart';
import 'package:mydemo_tabnavi2/pages/lesson_card_widget.dart';
import 'package:mydemo_tabnavi2/pages/video_player_2.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:mydemo_tabnavi2/widgets/okProgressBar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonPage extends StatefulWidget {
  final LessonDesc desc;
  final LessonData data;

  LessonPage({this.desc, this.data});

  @override
  State<LessonPage> createState() {
    // TODO: implement createState
    return LessonPageState();
  }
}

class LessonPageState extends State<LessonPage> {
  List<VideoDesc> videoDescList = [];
  List<VideoData> videoDataList = [];

  int activeIndex = -1;
  VideoData activeData = null;
  VideoDesc activeDesc = null;

  LessonPageState() {}

  @override
  void initState() {
    super.initState();

    videoDescList =
        LessonDescModel.singleton().queryVideoList(widget.desc.videoList);
    for (var desc in videoDescList) {
      videoDataList
          .add(LessonPlayModel.singleton().getVideoData(desc.videoKey));
    }

    activeIndex = videoDescList.length > 0 ? 0 : -1;
  }

  String getActiveVideoKey() {
    if (activeIndex >= 0)
      return videoDescList[activeIndex].videoKey;
    else
      return "";
  }

  void OnSelectVideo(VideoDesc videoDesc) {
    setState(() {
      int index =
          videoDescList.indexWhere((q) => q.videoKey == videoDesc.videoKey);

      activeIndex = index;
      activeDesc = videoDescList[index];
      activeData = videoDataList[index];
    });
  }

  //전역으로 사용할 수 있는 플레이 상태 오브젝트
  PlayerStateNotifier playState = PlayerStateNotifier();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
        backgroundColor: Styles.appBackground,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Styles.appBackground,
          leading:
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            GestureDetector(
                child: Icon(
                  CupertinoIcons.clear_thick,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "", //widget.desc.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ))
          ]),
          trailing: okSelectableIcon(
              initSelected: widget.data.favorited,
              onChangeState: (bool sel) {
                widget.data.favorited = sel;
                LessonPlayModel.singleton().notifyListeners();
              }),
        ),
        child: ChangeNotifierProvider<PlayerStateNotifier>.value(
            value: playState,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              VideoPlayerY(videoId: getActiveVideoKey()),
              Expanded(child: _buildVideoList())
            ])));
  }

  Widget _buildVideoList() {
    int itemCount = videoDescList.length;

    return ListView.builder(
        itemCount: itemCount + 2,
        itemBuilder: (context, index) {
          return Consumer<PlayerStateNotifier>(builder: (_, playState, __) {
            if (index == 0)
              return LessonCardSimpleWidget(widget.desc);
            else if (index <= itemCount)
              return _videoItem(videoDescList[index - 1]);
            else
              return _bottomDesc();
          });
        });
  }

  Widget _bottomDesc() {
    return Padding(
        padding: EdgeInsets.only(top: 50, bottom: 10),
        child: Container(
          height: 100,
          color: Colors.black12,
        ));
  }

  Widget _videoItem(VideoDesc desc) {
    //  String image =  desc.snippet.getThumnail(level:0);

    Image thumnail = Image.network(
      YoutubePlayer.getThumbnail(
          videoId: desc.videoKey, quality: ThumbnailQuality.standard),
      fit: BoxFit.fitHeight,
      alignment: Alignment.topLeft,
    );

    VideoData data = LessonPlayModel.singleton().getVideoData(desc.videoKey);

    // desc.snippet.
    String timeText = desc
        .playTimeText; //'${desc.snippet.durationH}H ${desc.snippet.durationM}분 ${desc.snippet.durationS}초';
    double p = desc.progress;

    //double totalTime = desc.snippet.durationM * 60.0 + desc.snippet.durationS;
    //double playTime = data.time;
    //double p = playTime / totalTime;

    IconData playIcon = Icons.radio_button_unchecked;

    if (data.completed)
      playIcon = Icons.brightness_1;
    else if (data.time > 0)
      playIcon = Icons.play_circle_outline;
    else
      playIcon = Icons.radio_button_unchecked;

    return Container(
      margin: EdgeInsets.only(top: 8.0),
      height: 74,
      //color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                OnSelectVideo(desc);
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 5, left: 5),
                  child: Icon(playIcon, size: 40, color: Colors.white))),
          Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: SizedBox(width: 80, height: 74, child: thumnail)),
          Expanded(
            child: Container(
              color: Colors.black45,
              child: Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Positioned(
                        left: 5,
                        top: 5,
                        child: Text(desc.snippet.title,
                            style: Styles.font15Text,
                            overflow: TextOverflow.ellipsis)),
                    Positioned(
                        left: 10,
                        bottom: 6,
                        child: Text(timeText,
                            textAlign: TextAlign.right,
                            style: Styles.font10Text,
                            overflow: TextOverflow.ellipsis)),
                    Positioned(
                      left: 80,
                      bottom: 9,
                      child: okProgressBar(width: 200, height: 8, p: p),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
