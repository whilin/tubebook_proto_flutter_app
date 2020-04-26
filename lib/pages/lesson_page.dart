import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mydemo_tabnavi2/pages/DialogUtils.dart';
import 'package:mydemo_tabnavi2/widgets/LessonWidget.dart';
import 'package:mydemo_tabnavi2/pages/VideoItemWidget.dart';
import 'package:mydemo_tabnavi2/widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/pages/LessonCardWidget.dart';
import 'package:mydemo_tabnavi2/pages/VideoPlayerV2.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:mydemo_tabnavi2/widgets/okProgressBar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'LessonProgressBarWidget.dart';
import 'VideoCompletedDailog.dart';

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
    with VideoPlayerControllerInterface, TickerProviderStateMixin {
  List<LessonVideo> videoDescList = [];
  List<VideoData> videoDataList = [];

  int activeIndex = -1;
  VideoData activeData = null;
  LessonVideo activeDesc = null;

  bool _fullScreenMode = false;

  //전역으로 사용할 수 있는 플레이 상태 오브젝트
  PlayerStateNotifier playState = PlayerStateNotifier();
  TabController _controller;
  int _selectedPage = 0;

  LessonPageState() {}

  @override
  void initState() {
    super.initState();

//    videoDescList =
//        LessonDescManager.singleton().queryVideoList(widget.desc.videoList);
//
    videoDescList = widget.desc.videoListEx;
    for (var desc in videoDescList) {
      videoDataList
          .add(LessonDataManager.singleton().getVideoData(desc.videoKey));
    }

    activeIndex = videoDescList.length > 0 ? 0 : -1;

    _controller =
        new TabController(length: 2, initialIndex: _selectedPage, vsync: this);

    _controller.addListener(() {
      _selectedPage = _controller.index;
      // setState(() {});
      playState.notifyListeners();
    });
  }

  LessonVideo getActiveVideoKey() {
    if (activeIndex >= 0)
      return videoDescList[activeIndex];
    else
      return null;
  }

  void OnSelectVideo(LessonVideo videoDesc) {
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
    setState(() {});
  }

  @override
  void onVideoCompleted() {
    confirmVideoCompleted();
  }

  void onSubscribe() {
    // VideoCompletedDialog.showDialogImpl(context, activeDesc);

    LessonDataManager.singleton().requestSubscribeLesson(widget.desc.lessonId,
        (result, err) {
      if (err != null) {
      } else {
        String msg = '[${widget.desc.title}] 시작합니다';
        DialogUtil.showToast(msg);
        setState(() {});
      }
    });
  }

  void confirmVideoCompleted() async {

    if (widget.data.subscribed && !activeData.completed) {
      bool response =
          await VideoCompletedDialog.showDialogImpl(context, activeDesc);
      if (response) {
        activeData.completed = true;
      }
      setState(() {});

      if (!widget.data.completed) {
        LessonDataManager.singleton()
            .requestLessonCompleted(widget.desc.lessonId, (data, err) {
          if (widget.data.completed) {

            print('Lesson Completed');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: _fullScreenMode ? Colors.black : Styles.appBackground,
        body: SafeArea(
            top: true,
            bottom: false,
            child: ChangeNotifierProvider<PlayerStateNotifier>.value(
                value: playState,
                child: Stack(children: [
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    VideoPlayerV2(
                      videoDesc: getActiveVideoKey(),
                      controllerInterface: this,
                    ),
                    //_buildTabSystem()[0],
                    Consumer<PlayerStateNotifier>(
                        builder: (context, playerNotifier, w) {
                      return Expanded(
                          child: CustomScrollView(slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          _buildActiveVideoName(),
                          widget.data.subscribed
                              ? _buildLessonDescriptorSub()
                              : _buildLessonDescriptor(),
                        ])),
                        SliverList(
                            delegate: SliverChildListDelegate(
                          _buildTabSystem(),
                        )),
                        _buildSelectedTabPage(),
                      ]));
                    })
                  ]),
                  _buildSubscribeButton(),
                ]))));
  }

  Widget _buildSubscribeButton() {
    if (!widget.data.subscribed && !_fullScreenMode) {
      return Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.topCenter,
            height: 80,
            color: Color(0xff37A000),
            child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '▶︎  레슨 시작하기',
                  style: Styles.font18Text,
                )),
          ),
          onTap: () {
            onSubscribe();
          },
        ),
      );
    } else {
      return new Container();
    }
  }

  List<Widget> _buildTabSystem() {
    var tabBar = TabBar(controller: _controller, tabs: [
      Tab(text: '동영상  리스트'),
      Tab(text: '레슨 상세 설명'),
    ]);

//
//    var tabView = Container(
//        height: 500,
//        child: TabBarView(
//          controller: _controller,
//          children: <Widget>[
//            _buildVideoList(),
//            Icon(Icons.directions_transit),
//          ],
//        ));

    return [tabBar];
  }

  SliverList _buildSelectedTabPage() {
    List<Widget> list;
    if (_selectedPage == 0) {
      list = _buildVideoListSliverChild();
    } else {
      list = _buildLessonDescListSliverChild();
    }

    return SliverList(delegate: SliverChildListDelegate(list));
  }

  Widget _buildActiveVideoName() {
    if (widget.data.subscribed && activeDesc != null) {
      return Container(
        height: 30,
        padding: EdgeInsets.only(left: 10),
        color: Colors.black45,
        alignment: Alignment.centerLeft,
        child: Text(
          '◉ ' + activeDesc.title,
          style: Styles.font12Text,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _buildLessonDescriptor() {
    return Container(
        padding:
            const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        child: LessonWidgets.buildDescriptor(widget.desc));
  }

  Widget _buildLessonDescriptorSub() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: LessonProgressBarWidget.forLesson(
        desc: widget.desc,
        onBarClick: () {},
        onSubscribeClick: onSubscribe,
      ),
    );
  }

  List<Widget> _buildVideoListSliverChild() {
    int itemCount = videoDescList.length;

    List<Widget> items = videoDescList.map((e) {
      return Consumer<PlayerStateNotifier>(builder: (_, playState, __) {
        return new VideoItemWidget(e, e == activeDesc, (desc) {
          OnSelectVideo(desc);
        });
      });
    }).toList();

    items.add(Consumer<PlayerStateNotifier>(builder: (_, playState, __) {
      return new Container(height: 100);
    }));

    return items;
  }

  Widget _buildVideoList() {
    int itemCount = videoDescList.length;

    return ListView.builder(
        itemCount: itemCount + 1,
        itemBuilder: (context, index) {
          return Consumer<PlayerStateNotifier>(builder: (_, playState, __) {
            if ((index) < itemCount)
              return VideoItemWidget(
                  videoDescList[index], videoDescList[index] == activeDesc,
                  (desc) {
                OnSelectVideo(desc);
              });
            else
              return Container(
                height: 50,
              );
          });
        });
  }

  List<Widget> _buildLessonDescListSliverChild() {
    List<Widget> descList = new List<Widget>();

    descList = [
      _buildSpace(),
      
//      _buildTitle('◼︎ 레슨에 대한 소개'),
//      _buildDesc(
//          '프로그램을 처음 배우는 사람들을 위한개 강의 입니다.언어에 대한 지식이 없어도 처음 부터 쉽게 따라할 수 있도록 만들어 졌습니다'),
//      _buildTitle('◼︎ 크리에이터 소개'),
//      소개

      _buildTitle(widget.desc.detailDescription ?? ''),
    ];

    return descList;
  }

  Widget _buildSpace() {
    return new Container(
      height: 10,
    );
  }

  Widget _buildTitle(String text) {
    return new Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: Styles.font15Text,
        ));
  }

  Widget _buildDesc(String text) {
    return new Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: Styles.font12Text,
        ));
  }
}
