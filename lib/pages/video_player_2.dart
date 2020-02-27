import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:mydemo_tabnavi2/datas/course_data_define.dart';
import 'package:mydemo_tabnavi2/datas/course_desc_model.dart';
import 'package:mydemo_tabnavi2/datas/course_play_model.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

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

// Youtube Player SDK Home
// https://pub.dev/packages/flutter_youtube_view#-readme-tab-
//

class VideoPlayerY extends StatefulWidget {
  // "https://youtu.be/Rc9mMISDQws"
  //final String url;
  final String videoId;

  VideoPlayerY({this.videoId});

  @override
  State<VideoPlayerY> createState() {
    // TODO: implement createState
    return VideoPlayerYState();
  }
}

class VideoPlayerYState extends State<VideoPlayerY>
    implements YouTubePlayerListener {
  //double _currentVideoSecond = 0.0;

  VideoDesc _videoDesc;
  VideoData _videoData;
  bool _fullScreenMode = false;
  bool _volumeOn = true;

  // String _playerState = "";
  FlutterYoutubeViewController _controller;

  VideoPlayerYState() {}

  @override
  void initState() {
    super.initState();

    _videoData = LessonPlayModel.singleton().getVideoData(widget.videoId);
    _videoDesc = LessonDescModel.singleton().getVideoDesc(widget.videoId);

    //Provider.of<PlayState>(context).playState;
  }

  @override
  void didUpdateWidget(covariant VideoPlayerY oldWidget) {
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
    print("onCurrentSecond second = $second");
    // _currentVideoSecond = second;
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

    if (state == "ENDED") _videoData.completed = true;

    // else if (state == "PLAYING")
    //  _videoData.playing = true;
  }

  @override
  void onVideoDuration(double duration) {
    print("onVideoDuration duration = $duration");
  }

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    this._controller = controller;
  }

  void updateVolumeOn()
  {
    setState(() {
      _volumeOn = !_volumeOn;
      if(_volumeOn)
        _controller.setUnMute();
      else
        _controller.setMute();
    });
  }

  void updateFullScreenMode()
  {
    setState(() {
      _fullScreenMode = !_fullScreenMode;
    });
  }

  void _loadOrCueVideo() {
    //if (_videoData != null) _videoData.playing = false;

    _videoData = LessonPlayModel.singleton().getVideoData(widget.videoId);
    _videoDesc = LessonDescModel.singleton().getVideoDesc(widget.videoId);

    Provider.of<PlayerStateNotifier>(context).readyVideo(widget.videoId);

    // _videoData.playing = true;

    _controller.loadOrCueVideo(widget.videoId, _videoData.time);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget player = Container(
        width: size.width,
        height: 270,
        color: Colors.black45,
        alignment: Alignment.center,
        child: FlutterYoutubeView(
            onViewCreated: _onYoutubeCreated,
            listener: this,
            scaleMode: YoutubeScaleMode.none,
            // <option> fitWidth, fitHeight
            params: YoutubeParam(
                videoId: widget.videoId,
                showUI: true,
                //startSeconds: 0.0, // <option>
                autoPlay: false) // <option>
            ));

    return Column(
      children: <Widget>[player, controlBar()],
    );
  }

  static String timeFormat(double time) {
    int min = (time / 60).floor();
    int sec = time.toInt() - (min * 60);

    return sprintf('%02i:%02i', [min, sec]);
  }

  Widget controlBar() {
    double playTime = _videoData.time;
    double totalTime = _videoDesc.totalPlayTime;
    String timeText = timeFormat(playTime) + ' / ' + timeFormat(totalTime);

    IconData iconData = Icons.play_arrow;
    var playState = Provider.of<PlayerStateNotifier>(context).playingState;

    if (playState == PlayingState.Playing)
      iconData = Icons.pause;
    else
      iconData = Icons.play_arrow;

    return Container(
      height: 35,
      color: Color(0xff143235),
      alignment: Alignment.center,
      child: Stack(children: [
        Row(
          children: <Widget>[
            GestureDetector(
                child: Icon(iconData, size: 30),
                onTap: () {
                  var playState =
                      Provider.of<PlayerStateNotifier>(context).playingState;
                  if (playState == PlayingState.Playing)
                    _controller.pause();
                  else
                    _controller.play();
                }),
            Text(timeText, style: Styles.font15Text)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                child: Icon(_volumeOn ? Icons.volume_up : Icons.volume_off,
                    size: 30),
                onTap: updateVolumeOn),
            GestureDetector(
                child: Icon(Icons.fullscreen, size: 30),
                onTap: updateFullScreenMode),
          ],
        )
      ]),
    );
  }
}
