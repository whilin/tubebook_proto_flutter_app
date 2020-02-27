import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


//
// https://pub.dev/packages/youtube_player_flutter#-readme-tab-
//

class VideoPlayer extends StatefulWidget {

  // "https://youtu.be/Rc9mMISDQws"
  //final String url;
  final String videoId;

  VideoPlayer({this.videoId});

  @override
  State<VideoPlayer> createState() {
    // TODO: implement createState
    return VideoPlayerState();
  }

}

class VideoPlayerState extends State<VideoPlayer> {

  String _videoId;
  YoutubePlayerController _controller;

  VideoPlayerState() {

  }

  @override
  void initState() {
    super.initState();

   // _videoId = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        forceHideAnnotation: true,
        //controlsVisibleAtStart : true,
        //isLive: true,
      ),
    );

    var value = _controller.value.copyWith(isFullScreen:  false);
    _controller.updateValue(value);

  }

  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.load(widget.videoId);

    /*
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        forceHideAnnotation: true,
        //controlsVisibleAtStart : true,
        //isLive: true,
      ),
    );

    var value = _controller.value.copyWith(isFullScreen:  false);
    _controller.updateValue(value);
     */
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {


    Widget player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {
        print('Player is ready.');

        // _controller.toggleFullScreenMode();
        //var value = _controller.value.copyWith(isFullScreen:  false);
        //_controller.updateValue(value);
      },
      onEnded: (YoutubeMetaData metaData) {
        print('Play on end');
      },
    );

    Widget bar = Container(
      height: 35,
      color: Color(0xff143235),
    );

    return Column (
      children: <Widget>[player, bar],
    );
  }

}