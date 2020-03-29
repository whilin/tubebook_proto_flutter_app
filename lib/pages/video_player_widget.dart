import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:provider/provider.dart';
import 'package:seekbar/seekbar.dart';
import 'package:sprintf/sprintf.dart';
import 'package:async/async.dart';

class PlayerStateNotifier with ChangeNotifier {
  PlayerStateNotifier();

  String videoKey = '';
  String playState = "PAUSED";
  double playTime = 0;

  PlayingState playingState = PlayingState.Unread;

  void updatePlayTime(double time) {
    playTime = time;
    notifyListeners();
  }

  void updatePlayState(String state) {
    playState = state;

    if (playState == 'PLAYING')
      playingState = PlayingState.Playing;
    else if (playState == 'PAUSED') playingState = PlayingState.Paused;

    notifyListeners();
  }

  void readyVideo(String videoKey) {
    this.videoKey = videoKey;
    notifyListeners();
  }
}

class VideoPlayerControllerInterface {
  void onCloseWindowEvent() {}

  void onFullscreenEvent(bool on) {}
}

// Youtube Player SDK Home
// https://pub.dev/packages/flutter_youtube_view#-readme-tab-
//

class VideoPlayerV2 extends StatefulWidget {
  // "https://youtu.be/Rc9mMISDQws"
  //final String url;
  final String videoId;
  final VideoPlayerControllerInterface controllerInterface;

  VideoPlayerV2({this.videoId, this.controllerInterface});

  @override
  State<VideoPlayerV2> createState() {
    // TODO: implement createState
    return VideoPlayerV2State();
  }
}

class VideoPlayerV2State extends State<VideoPlayerV2>
    implements YouTubePlayerListener {
  double _currentVideoSecond = 0.0;

  VideoDesc _videoDesc;
  VideoData _videoData;
  bool _fullScreenMode = false;
  bool _volumeOn = true;

  bool _screenReady = false;
  bool _screenOverlayControl = false;

  double _duration = 0.0;

  // String _playerState = "";
  FlutterYoutubeViewController _controller;

  VideoPlayerV2State() {}

  @override
  void initState() {
    super.initState();

    _videoData = LessonDataManager.singleton().getVideoData(widget.videoId);
    _videoDesc = LessonDescManager.singleton().getVideoDesc(widget.videoId);

    waitForScreenReady();
  }

  Future waitForScreenReady() async {
    _screenReady = false;

    await Future.delayed(new Duration(milliseconds: 300));
    setState(() {
      _screenReady = true;
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerV2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadOrCueVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();

    Provider.of<PlayerStateNotifier>(context).readyVideo(null);

    //if (_videoData != null)
    // _videoData.playing = false;
  }

  @override
  void onCurrentSecond(double second) {
    //print("onCurrentSecond second = $second");
    _currentVideoSecond = second;

    _videoData.time = second;
    Provider.of<PlayerStateNotifier>(context).updatePlayTime(second);
    //_videoData.playing = true;
  }

  @override
  void onError(String error) {
    print("onError error = $error");
  }

  @override
  void onReady() {
    print("onReady");
  }

  @override
  void onStateChange(String state) {
    print("onStateChange state = $state");

    Provider.of<PlayerStateNotifier>(context).updatePlayState(state);
/*
    if (state == "ENDED")
      _videoData.completed = true;
    else if (state == "PAUSED")
      _screenOverlayControl = true;
    else if (state == "PLAYING") _screenOverlayControl = false;
*/
    // else if (state == "PLAYING")
    //  _videoData.playing = true;
  }

  @override
  void onVideoDuration(double duration) {
    _duration = duration;
    //print("onVideoDuration duration = $duration");
  }

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    this._controller = controller;
  }

  void updateVolumeOn() {
    setState(() {
      _volumeOn = !_volumeOn;
      if (_volumeOn)
        _controller.setUnMute();
      else
        _controller.setMute();
    });
  }

  void updateFullScreenMode() {
    _fullScreenMode = !_fullScreenMode;

    if (_fullScreenMode) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    widget.controllerInterface.onFullscreenEvent(_fullScreenMode);
    waitForScreenReady();
//
//    setState(() {
//     // _fullScreenMode = !_fullScreenMode;
//     // _controller.changeScaleMode(Y)
//      //_controller.loadOrCueVideo(videoId, startSeconds)
//
//
//    });
  }

  void _loadOrCueVideo() {
    //if (_videoData != null) _videoData.playing = false;

    _videoData = LessonDataManager.singleton().getVideoData(widget.videoId);
    _videoDesc = LessonDescManager.singleton().getVideoDesc(widget.videoId);

    Provider.of<PlayerStateNotifier>(context).readyVideo(widget.videoId);

    // _videoData.playing = true;

    _controller.loadOrCueVideo(widget.videoId, _videoData.time);
    _showScreenOverlay();
  }

  void forwardPlaytime(int seconds) {
    setState(() {
      _currentVideoSecond += seconds;
      _currentVideoSecond = _currentVideoSecond.clamp(0, _duration);
      _controller.seekTo(_currentVideoSecond);
    });

    _showScreenOverlay();
  }

  void jumpPlaytime(double p) {
    double totalTime = _videoDesc.totalPlayTime;
    _controller.seekTo(totalTime * p);

    _showScreenOverlay();
  }

  void playOrPause() {
    var playState = Provider.of<PlayerStateNotifier>(context).playingState;
    if (playState == PlayingState.Playing)
      _controller.pause();
    else
      _controller.play();

    _showScreenOverlay();
  }

  Timer _autoHideTimer = null;

  void _showScreenOverlay() {

    if( !_screenOverlayControl ){
      setState(() {
        _screenOverlayControl = true;
      });
    }

    if (_autoHideTimer != null)
      _autoHideTimer.cancel();

    print('autoHideScreenOverlay_ schedule');

    _autoHideTimer = Timer(Duration(seconds: 10),() {
      print('autoHideScreenOverlay_ done');
      _autoHideTimer = null;
      setState(() {
        _screenOverlayControl = false;
      });
    });
  }

  /*
  CancelableOperation _cancelableOperation;


  void autoHideScreenOverlay() {

    if (_cancelableOperation != null)
      _cancelableOperation.cancel();

    print('autoHideScreenOverlay_ schedule');

    final call = Future.delayed(Duration(seconds: 10),() {
      print('autoHideScreenOverlay_ done');
      _cancelableOperation = null;
      setState(() {
        _screenOverlayControl = false;
      });
    });

    // waitingAsyncCall.
    _cancelableOperation = CancelableOperation.fromFuture(call, onCancel: () {
      print("autoHideScreenOverlay_ cancel");
    });
  }
*/

  /*
  CancelableOperation op =null;
  void autoHideScreenOverlay() {

    if(op!=null)
      op.cancel();

      op = CancelableOperation.fromFuture( Future.delayed(Duration(seconds: 10), () {
      print('Future.delayed then');
      if (!op.isCanceled)
        setState(() {
          _screenOverlayControl = false;
        });
    }));
  }
*/

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var width = 0.0; //size.width;
    var height = 0.0; //toHDHeight(size.width)-100;

    //var size = MediaQuery.of(context).size;
    if (size.width > size.height)
      _fullScreenMode = true;
    else
      _fullScreenMode = false;

    if (!_fullScreenMode) {
      width = size.width;
      height = toHDHeight(width);
    } else {
      height = size.height;
      width = toHDWidth(height);
    }

    Widget player = Container(
        width: width,
        height: height,
        color: Colors.black,
        alignment: Alignment.center,
        child: _screenReady == false
            ? null
            : FlutterYoutubeView(
                onViewCreated: _onYoutubeCreated,
                listener: this,
                scaleMode: YoutubeScaleMode.fitWidth,
                // <option> fitWidth, fitHeight
                params: YoutubeParam(
                    videoId: widget.videoId,
                    showUI: false,
                    startSeconds: _currentVideoSecond, // <option>
                    autoPlay: _currentVideoSecond > 0) // <option>
                ));

    Widget gesture = GestureDetector(
      child: AbsorbPointer(
        child: player,
        absorbing: true,
      ),
      onVerticalDragEnd: (DragEndDetails e) {
        print('DragDownDetails=' + e.toString());
        if (e.velocity.pixelsPerSecond.dy > 1000) {
          print('Close =' + e.toString());
          widget.controllerInterface.onCloseWindowEvent();
        }
      },
      onTapDown: (TapDownDetails details) {
        setState(() {
          print(details.toString());
          _screenOverlayControl = !_screenOverlayControl;

          if (_screenOverlayControl)
            _showScreenOverlay();
        });
      },
    );

    return Column(children: <Widget>[
      Stack(
        children: [gesture, _screenOverController(width, height)],
      )
    ]);

    /*
    if (_fullScreenMode) {
      return Column(children: <Widget>[
        Stack(
          children: [
            gesture,
            _screenOverController(width, height)

          ],
        )
      ]);
    } else {
      return Column(
        children: <Widget>[
          Stack(children: [
            gesture,
            _screenOverController(width, height)
          ]),
          //controlBar(false)
        ],
      );
    }
     */
  }

  static String timeFormat(double time) {
    int min = (time / 60).floor();
    int sec = time.toInt() - (min * 60);

    return sprintf('%02i:%02i', [min, sec]);
  }

  Widget _screenOverController(double width, double height) {
    return _screenOverlayControl
        ? _screenOverControllerShow(width, height)
        : Container(height: height, width: width);
  }

  Widget _screenOverControllerShow(double width, double height) {

    var playState = Provider.of<PlayerStateNotifier>(context).playingState;

    IconData playIconData = (playState == PlayingState.Playing) ? Icons.pause : Icons.play_arrow;

    return Container(
        height: height,
        width: width,
        color: Colors.black38,
        child: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              iconSize: 30,
              onPressed: widget.controllerInterface.onCloseWindowEvent,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_rewind,
                          size: 30, color: Colors.white),
                      onPressed: () {
                        forwardPlaytime(-10);
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(playIconData,
                          size: 30, color: Colors.white),
                      onPressed: playOrPause,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_forward,
                          size: 30, color: Colors.white),
                      onPressed: () {
                        forwardPlaytime(10);
                      },
                    ),
                    Spacer(),
                  ])),
          Align(
              alignment: Alignment.bottomCenter,
              child: screenOverController_bottom())
        ]));
  }

  Widget screenOverController_bottom() {
    double playTime = _videoData.time;
    double totalTime = _videoDesc.totalPlayTime;
    String timeText = timeFormat(playTime) + ' / ' + timeFormat(totalTime);

    IconData iconData = Icons.play_arrow;
    var playState = Provider.of<PlayerStateNotifier>(context).playingState;

    return Container(
        height: 50,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Positioned(
                left: 20,
                bottom: 8,
                child: Text(timeText, style: Styles.font10Text)),
            Positioned(
              left: 10,
              bottom: 22,
              right: 80,
              child: SeekBar(
                  value: playTime / totalTime,
                  progressColor: Colors.red,
                  onProgressChanged: (value) {
                    jumpPlaytime(value);
                  }),
            ),
            Positioned(
                right: 30,
                bottom: 5,
                child: IconButton(
                    iconSize: 25,
                    icon: Icon(
                      _volumeOn ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                    onPressed: updateVolumeOn)),
            Positioned(
                right: 0,
                bottom: 5,
                child: IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: updateFullScreenMode)),
          ],
        ));
  }

  //Note. 독립된 바텀 컨트롤러
  Widget controlBar(bool fullScreenMode) {
    double playTime = _currentVideoSecond;// _videoData.time;
    double totalTime = _videoDesc.totalPlayTime;
    String timeText = timeFormat(playTime) + ' / ' + timeFormat(totalTime);

    IconData iconData = Icons.play_arrow;
    var playState = Provider.of<PlayerStateNotifier>(context).playingState;

    if (playState == PlayingState.Playing)
      iconData = Icons.pause;
    else
      iconData = Icons.play_arrow;

    return Container(
      height: 50,
      color: fullScreenMode ? Colors.black87 : Colors.black12,
      alignment: Alignment.center,
      child: Stack(children: [
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.fast_rewind,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  // _controller.setPlaybackRate(Pl)
                  forwardPlaytime(-10);
                }),
            IconButton(
                icon: Icon(
                  iconData,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  var playState =
                      Provider.of<PlayerStateNotifier>(context).playingState;
                  if (playState == PlayingState.Playing)
                    _controller.pause();
                  else
                    _controller.play();
                }),
            IconButton(
                icon: Icon(
                  Icons.fast_forward,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  forwardPlaytime(10);
                }),
            Text(timeText, style: Styles.font15Text)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  _volumeOn ? Icons.volume_up : Icons.volume_off,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: updateVolumeOn),
            IconButton(
                icon: Icon(
                  Icons.fullscreen,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: updateFullScreenMode),
          ],
        )
      ]),
    );
  }
}

/*
class _ScreenControllerInterface {
  void onCloseWindowEvent() {}
  void onFullscreenEvent(bool on) {}

  void seekPlaytime(int secTime) {}
  void playOrPause() {}
}

class _ScreenOverlayController extends StatefulWidget {

  final _ScreenControllerInterface controller;

  _ScreenOverlayController(this.controller) {

  }

  @override
  __ScreenOverlayControllerState createState() => __ScreenOverlayControllerState();
}

class __ScreenOverlayControllerState extends State<_ScreenOverlayController> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // TODO: implement build
    return screenOverController(size.width, size.height);
  }

  Widget screenOverController(double width, double height) {

    return SizedBox(
        height: height,
        width: width,
        child: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.amber,
              ),
              iconSize: 30,
              onPressed: widget.controller.onCloseWindowEvent,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_rewind,
                          size: 50, color: Colors.amber),
                      onPressed: () {
                        widget.controller.seekPlaytime(-10);
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.play_circle_filled,
                          size: 50, color: Colors.amber),
                      onPressed: widget.controller.playOrPause,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_forward,
                          size: 50, color: Colors.amber),
                      onPressed: () {
                        widget.controller.seekPlaytime(10);
                      },
                    ),
                    Spacer(),
                  ]))
        ]));
  }
}
 */
