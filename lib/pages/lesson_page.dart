import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mydemo_tabnavi2/common_widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/widgets/lesson_card_widget.dart';
import 'package:mydemo_tabnavi2/pages/video_player_widget.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:mydemo_tabnavi2/common_widgets/okProgressBar.dart';
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

class LessonPageState extends State<LessonPage>
    with VideoPlayerControllerInterface {
  List<VideoDesc> videoDescList = [];
  List<VideoData> videoDataList = [];

  int activeIndex = -1;
  VideoData activeData = null;
  VideoDesc activeDesc = null;

  bool _fullScreenMode = false;

  //전역으로 사용할 수 있는 플레이 상태 오브젝트
  PlayerStateNotifier playState = PlayerStateNotifier();

  LessonPageState() {}

  @override
  void initState() {
    super.initState();

    videoDescList =
        LessonDescManager.singleton().queryVideoList(widget.desc.videoList);
    for (var desc in videoDescList) {
      videoDataList
          .add(LessonDataManager.singleton().getVideoData(desc.videoKey));
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

  @override
  void onCloseWindowEvent() {
    super.onCloseWindowEvent();
    Navigator.of(context).pop();
  }

  @override
  void onFullscreenEvent(bool on) {
    _fullScreenMode = on;
    setState(() {

    });
  }

  void onSubscribe() {
    LessonDataManager.singleton().requestSubscribeLesson(widget.desc.lessonId,
        (result, err) {
      if (err != null) {
      } else {
        String msg = '[${widget.desc.title}]를 시작합니다';
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: _fullScreenMode ?  Colors.black : Styles.appBackground,
        /*
        appBar: AppBar(
          backgroundColor: Styles.appBackground,
          leading:
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed : () {
                  Navigator.of(context).pop();
                }),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "",///widget.desc.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ))
          ]),
          title: Text(widget.desc.title, style: Styles.font15Text, textAlign: TextAlign.center,),
          actions: [
            okSelectableIcon(
              iconDataOn: Icons.favorite,
                iconDataOff: Icons.favorite_border,
                initSelected: widget.data.favorited,
                onChangeState: (bool sel) {
                  widget.data.favorited = sel;
                  LessonDataManager.singleton().notifyListeners();
                })
          ],
        ),
         */
        body: SafeArea(
            top: true,
            bottom: false,
            child: ChangeNotifierProvider<PlayerStateNotifier>.value(
                value: playState,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  VideoPlayerV2(
                    videoId: getActiveVideoKey(),
                    controllerInterface: this,
                  ),
                  Expanded(child: _buildVideoList())
                ]))));
  }

  Widget _buildVideoList() {
    int itemCount = videoDescList.length;

    return ListView.builder(
        itemCount: itemCount + 3,
        itemBuilder: (context, index) {
          return Consumer<PlayerStateNotifier>(builder: (_, playState, __) {
            if (index == 1)
              return Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 10, left: 20, right: 20),
                child: LessonCardDetailBarWidget.forLesson(
                  desc: widget.desc,
                  onBarClick: () {},
                  onSubscribeClick: onSubscribe,
                ),
                //   child: LessonCardSimpleWidget(widget.desc),
              );
            else if (index == 0)
              return _lessonDesc();
            else if ((index - 2) < itemCount)
              return _videoItem(videoDescList[index - 2]);
            else
              return Container(
                height: 50,
              );
          });
        });
  }

  Widget _lessonDesc() {
    return new Column(children: [
      Padding(
          padding: EdgeInsets.only(top: 5, bottom: 10),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 100,
            //color: Colors.black12,
            child: Text(
              '이 레슨을 플러터를 처음 배우는 분들을 위해 준비한 강좌입니다.\n이 레슨을 플러터를 처음 배우는 분들을 위해 준비한 강좌입니다',
              style: new TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )),
//    Padding(
//    padding: EdgeInsets.symmetric(horizontal: 10),
//    child : Divider(color: Colors.black12, height: 1,thickness: 2))
    ]);
  }

  Widget _videoItem(VideoDesc desc) {
    //  String image =  desc.snippet.getThumnail(level:0);

    Image thumnail = Image.network(
      YoutubePlayer.getThumbnail(
          videoId: desc.videoKey, quality: ThumbnailQuality.standard),
      fit: BoxFit.fitHeight,
      alignment: Alignment.topLeft,
    );

    var imageUrl = YoutubePlayer.getThumbnail(
        videoId: desc.videoKey, quality: ThumbnailQuality.standard);

    VideoData data = LessonDataManager.singleton().getVideoData(desc.videoKey);

    // desc.snippet.
    String timeText = desc
        .playTimeText; //'${desc.snippet.durationH}H ${desc.snippet.durationM}분 ${desc.snippet.durationS}초';
    double p = getVideoProgress(desc);

    //double totalTime = desc.snippet.durationM * 60.0 + desc.snippet.durationS;
    //double playTime = data.time;
    //double p = playTime / totalTime;

    IconData playIcon = Icons.radio_button_unchecked;

    if (data.completed)
      playIcon = Icons.brightness_1;
    else if (data.time > 0)
      playIcon = Icons.play_arrow;
    else
      playIcon = Icons.radio_button_unchecked;

    final double height = 90.0;

    return Container(
        margin: EdgeInsets.only(top: 12.0),
        height: height,
        //color: Colors.amber,
        child: GestureDetector(
          onTap: () {
            OnSelectVideo(desc);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
//              Padding(
//                  padding: EdgeInsets.only(right: 0, left: 0),
//                  child: Icon(playIcon, size: 38, color: Colors.white)),
              Padding(
                  padding: EdgeInsets.only(left: 5, right: 0),
                  child: Container(
                      width: toSDWidth(height),
                      height: height,
                      child: Stack(children: [
                        Container(
                          // child : thumnail,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.fitHeight,
                                  colorFilter:
                                      ColorFilter.srgbToLinearGamma())),
                        ),
                        Center(
                            child:
                                Icon(playIcon, size: 50, color: Colors.white))
                      ]))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Container(
                    //  color: Colors.black12,
                    child: Stack(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Positioned(
                              left: 10,
                              top: 15,
                              right: 5,
                              child: Text(desc.snippet.title,
                                  style: Styles.font13Text,
                                  overflow: TextOverflow.ellipsis)),
                          Positioned(
                              left: 10,
                              bottom: 25,
                              child: SizedBox(
                                  width: 80,
                                  child: Text(timeText,
                                      textAlign: TextAlign.left,
                                      style: Styles.font10Text,
                                      overflow: TextOverflow.ellipsis))),
                          Positioned(
                            left: 10,
                            bottom: 15,
                            child: okProgressBar(width: 190, height: 8, p: p),
                          )
                        ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
