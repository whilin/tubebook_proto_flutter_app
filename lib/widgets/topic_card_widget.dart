import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/widgets/cardWidgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/pages/lesson_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../styles.dart';
import '../pages/topic_page_ex.dart';

class TopicCard extends StatelessWidget {
  /// Veggie to be displayed by the card.
  final TopicDesc desc;
  final double width;
  final double height;
  final bool page;

  TopicCard.tile(this.desc, {this.width, this.height}) : this.page = false {}

  TopicCard.page(this.desc, {this.width, this.height}) : this.page = true {}

  void onClickTopic(BuildContext context) {
    Navigator.of(context).push<void>(CupertinoPageRoute(
      builder: (context) => new TopicPageEx(desc),
      fullscreenDialog: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: () {
        onClickTopic(context);
      },
      child: Stack(
        fit: StackFit.loose,
        children: [
          Semantics(
            label: 'A card background featuring ${desc.name}',
            child: Hero(
                tag: page ? desc.topicId + '_page' : desc.topicId,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  height: height,
                 // color: Colors.white,
                  //height: 200, //isInSeason ? 300 : 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      colorFilter: null,
                      //isInSeason ? null : Styles.desaturatedColorFilter,
                      image: getTopicLogo(desc.topicId),
                    ),
                  ),
                )),
          ),
//          Positioned(
//            bottom: 0,
//            left: 0,
//            right: 0,
//            child: _buildDetails(),
//          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return FrostyBackground(
      color: Colors.black12,// Color(0x00ffffff),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              desc.name,
              style: Styles.font15Text,
            ),
//            Text(
//              desc.description,
//              style: Styles.font15Text,
//            ),
          ],
        ),
      ),
    );
  }
}


class LessonBannerCard extends StatelessWidget {
  /// Veggie to be displayed by the card.
  final LessonDesc desc;
  final double width;
  final double height;
  final bool page;

  LessonBannerCard.tile(this.desc, {this.width, this.height})
      : this.page = false {}

  LessonBannerCard.page(this.desc, {this.width, this.height}) : this.page = true {}

  void onClick(BuildContext context) {

    Navigator.of(context).push<void>(CupertinoPageRoute(
      builder: (context) => new LessonPage(
          desc: desc,
          data: LessonDataManager.singleton().getLessonData(desc.lessonId)),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    String bgImage = YoutubePlayer.getThumbnail(
        videoId: desc.videoListEx[0].videoKey, quality: ThumbnailQuality.standard);

    return PressableCard(
      onPressed: () {

        onClick(context);
      },
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: Image.network(bgImage, fit: BoxFit.fitWidth),
            //height: 200, //isInSeason ? 300 : 150,
            decoration: BoxDecoration(),
          ),
          Positioned(
            height: 50,
            bottom: 10,
            left: 0,
            right: 0,
            child: _buildDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return FrostyBackground(
      color: Color(0x00ffffff),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              desc.title,
              style: Styles.font18Text,
            ),
//            Text(
//              desc.description,
//              style: Styles.font15Text,
//            ),
          ],
        ),
      ),
    );
  }
}


class VideoBannerCard extends StatelessWidget {
  /// Veggie to be displayed by the card.

  final LessonDesc lesson;
  final LessonVideo video;
  final double width;
  final double height;
  final bool page;

  VideoBannerCard.page(this.lesson, this.video, {this.width, this.height}) : this.page = true {}

  void onClick(BuildContext context) {

    Navigator.of(context).push<void>(CupertinoPageRoute(
      builder: (context) => new LessonPage(
          desc: lesson,
          data: LessonDataManager.singleton().getLessonData(lesson.lessonId)),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    String bgImage = YoutubePlayer.getThumbnail(
        videoId: video.videoKey, quality: ThumbnailQuality.standard);

    return PressableCard(
      onPressed: () {

        onClick(context);
      },
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: Image.network(bgImage, fit: BoxFit.fitWidth),
            //height: 200, //isInSeason ? 300 : 150,
            decoration: BoxDecoration(),
          ),
          Positioned(
            height: 50,
            bottom: 10,
            left: 0,
            right: 0,
            child: _buildDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return FrostyBackground(
      color: Color(0x00ffffff),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              video.title,
              style: Styles.font16Text,
            ),
//            Text(
//              desc.description,
//              style: Styles.font15Text,
//            ),
          ],
        ),
      ),
    );
  }
}