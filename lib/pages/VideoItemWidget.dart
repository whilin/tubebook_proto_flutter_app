
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../styles.dart';
import '../widgets/okProgressBar.dart';

class VideoItemWidget extends StatelessWidget {
  final VideoDesc desc;
  final void Function(VideoDesc) onSelected;
  final bool isPlaying;

  VideoItemWidget(this.desc,this.isPlaying, this.onSelected);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _videoItem(desc);
  }

  Widget _videoItem(VideoDesc desc) {

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

    double p = getVideoProgressMax(desc);

    IconData playIcon = null;//Icons.radio_button_unchecked;

    if (data.completed)
      playIcon = Icons.check_circle;
    else if (data.maxTime > 0)
      playIcon = Icons.play_arrow;
//    else
//      playIcon = Icons.radio_button_unchecked;

    Widget mark = playIcon !=null ? Center(
        child:
        Icon(playIcon, size: 50, color: Colors.lightGreenAccent)) : Container();

    final double height = 96.0;

    return Container(
        margin: EdgeInsets.only(top: 12.0),
        height: height,
        color: isPlaying ? Colors.black12 : Colors.transparent,
        child: GestureDetector(
          onTap: () {
            onSelected(desc);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                                  fit: BoxFit.fill,
                                  colorFilter:
                                  ColorFilter.srgbToLinearGamma())),
                        ),
                        mark
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
                              right: 20,
                              child: Text(desc.snippet.title,
                                  style: Styles.font12Text,
                                  overflow: TextOverflow.visible)),
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
