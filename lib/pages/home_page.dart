import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/pages/splash_page.dart';
import 'package:mydemo_tabnavi2/sandbag/topic_page.dart';
import 'package:mydemo_tabnavi2/widgets/cardWidgets.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../styles.dart';
import '../widgets/topic_card_widget.dart';
import 'topic_page_ex.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();

//
//    Navigator.of(context).push<void>(CupertinoPageRoute(
//      builder: (context) => new SplashPage(),
//      fullscreenDialog: false,
//    ));
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LessonDescManager>(context);

    return Scaffold(
      //appBar: AppBar(title : Text('hello')),
        backgroundColor: Color(0xff3C3C3C),
        body: SafeArea(
            top: false,
            child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xff3C3C3C)),
                child: buildList(model))));
  }

  ListView buildList(LessonDescManager model) {
    return ListView(scrollDirection: Axis.vertical, children: [
      PagingBannerLessonList.hotTrend('HotTrend',
          minorTitle: 'HOT TRENDING', majorTitle: '앞서가는 개발자들이 봐야할 최신 강의'),
      Container(
        height: 20,
      ),
      TopicListSection.section(
        'NativeApp',
        minorTitle: 'Native APP',
        majorTitle: '기본에서 최고까지! PRO-라면 가야할 길',
      ),
      Container(
        height: 20,
      ),
      PagingBannerVideoList(
          minorTitle: 'TODAY Tech Talk', lessonId: 'dN0JGDI2Ds5XtK4oC1xT1D4Y'),

      Container(
        height: 10,
      ),
      TopicListSection.section(
        'HybridApp',
        minorTitle: 'Hybrid APP',
        majorTitle: '차세대 앱 개발을 위한 새로운 선택',
      ),
      Container(
        height: 10,
      ),
      //PagingBannerLessonList.subtopic('topic_jongok_0'),
      TopicBannerSection.section('topic_jongok_0'),
      Container(
        height: 20,
      ),
      TopicListSection.section(
        'Web',
        minorTitle: 'WEB',
        majorTitle: '웹 비지니스의 시작을 위한 핵심 기술!',
      ),
      Container(
        height: 10,
      ),
      TopicListSection.section(
        'Backend',
        minorTitle: 'Backend Tech',
        majorTitle: '웹 비지니스의 시작을 위한 핵심 기술!',
      ),
      Container(
        height: 20,
      ),
    ]);
  }
}

class TopicListSection extends StatelessWidget {

  List<TopicDesc> list;

  final String minorTitle; //= "HOT TRENDING";
  final String majorTitle; //= "앞서가는 개발자들이 봐야할 강의들";

  TopicListSection.section(String section, {this.minorTitle, this.majorTitle}) {
    list = LessonDescManager.singleton().getTopicListBySection(section);
  }

  //TopicsSection.list(List<TopicDesc> this.list) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<LessonDescManager>(builder: (_, model, __) {
      return categoryCardListView(list);
    });
  }

  Widget categoryCardListView(List<TopicDesc> list) {
    final listView = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return buildTopicCard(list[index]);
        });

    final box = SizedBox(
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(minorTitle, style: Styles.sectionText),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(majorTitle, style: Styles.sectionTitle),
            ),
            Container(
              height: 5,
            ),
            Expanded(child: listView)
          ],
        ));

    return box;
  }

  Widget buildTopicCard(TopicDesc desc) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        child: TopicCard.tile(
          desc,
          width: 160,
          height: 160,
        ));
  }
}


class TopicBannerSection extends StatelessWidget {

  TopicDesc list;
  LessonDesc titlelesson;

  String minorTitle; //= "HOT TRENDING";
  String majorTitle; //= "앞서가는 개발자들이 봐야할 강의들";

  TopicBannerSection.section(String topicId,
      {this.minorTitle, this.majorTitle}) {

    list = LessonDescManager.singleton().getTopic(topicId);
    if(list !=null) {
      var lessonList = LessonDescManager.singleton().queryLessonListByTopic(
          topicId);
      titlelesson = lessonList[0];

      majorTitle = list.name;
      minorTitle = 'BEST';
    }
  }

  void onClickTopic(BuildContext context) {
    Navigator.of(context).push<void>(CupertinoPageRoute(
      builder: (context) => new TopicPageEx(list),
      fullscreenDialog: false,
    ));
  }
  //TopicsSection.list(List<TopicDesc> this.list) {}

  @override
  Widget build(BuildContext context) {

    return Consumer<LessonDescManager>(builder: (_, model, __) {
      if(list !=null) {
        return categoryCardListView(context, list);
      } else {
        return Container();
      }
    });
  }


  Widget categoryCardListView(BuildContext context, TopicDesc list) {

    final w = MediaQuery
        .of(context)
        .size
        .width;
    final h = MediaQuery
        .of(context)
        .size
        .height;

    final box = Container(
        height: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(minorTitle, style: Styles.sectionText),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(majorTitle, style: Styles.sectionTitle),
            ),
            Container(
              height: 5,
            ),
            Expanded(
                child: Padding(
                    padding:
                    EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
                    child:
                    _buildBannerTile(context, w, h))
            )
          ],
        ));

    return box;
  }


  Widget _buildBannerTile(BuildContext context, double width, double height) {

    String bgImage = YoutubePlayer.getThumbnail(
        videoId: titlelesson.videoListEx[0].videoKey, quality: ThumbnailQuality.standard);


    return PressableCard(
      onPressed: () {
        onClickTopic(context);
      },
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  height: height,
                  // color: Colors.white,
                  //height: 200, //isInSeason ? 300 : 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      colorFilter: null,
                      //isInSeason ? null : Styles.desaturatedColorFilter,
                      image: NetworkImage(bgImage),
                    ),
                  ),
                )]),
          );
  }
}

class PagingBannerLessonList extends StatelessWidget {

  List<LessonDesc> list;

  String minorTitle; //= "HOT TRENDING";
  String majorTitle; //= "앞서가는 개발자들이 봐야할 강의들";

  PagingBannerLessonList.hotTrend(String section,
      {this.minorTitle, this.majorTitle}) {
    list = LessonDescManager.singleton().queryHotTrends();
  }

  PagingBannerLessonList.subtopic(String subTopicId) {
    var topic = LessonDescManager.singleton().getTopic(subTopicId);
    if (topic != null) {
      majorTitle = topic.name;
      minorTitle = 'BEST CURATION';
      list =
          LessonDescManager.singleton().queryLessonListBySubTopic(subTopicId);
    } else {
      majorTitle = '';
      minorTitle = '';
      list = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<LessonDescManager>(builder: (_, model, __) {
      return categoryCardListView(list);
    });
  }

  Widget categoryCardListView(List<LessonDesc> list) {
    final box = Container(
        height: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(minorTitle, style: Styles.sectionText),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(majorTitle, style: Styles.sectionTitle),
            ),
            Container(
              height: 5,
            ),
            Expanded(
                child: Swiper(
                  autoplay: true,
                  viewportFraction: 1.0,
                  itemBuilder: (BuildContext context, int index) {
                    final w = MediaQuery
                        .of(context)
                        .size
                        .width;
                    final h = MediaQuery
                        .of(context)
                        .size
                        .height;

                    return Padding(
                        padding:
                        EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
                        child:
                        LessonBannerCard.page(
                            list[index], width: w, height: h));
                  },
                  itemCount: list.length,
                  pagination: SwiperPagination(
                      margin: EdgeInsets.only(bottom: 15.0),
                      builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.white,
                          color: Colors.grey,
                          size: 5,
                          activeSize: 8,
                          space: 3.0)),
                ))
          ],
        ));

    return box;
  }

  Widget buildTopicCard(TopicDesc desc) {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
        child: TopicCard.page(desc));
  }
}


class PagingBannerVideoList extends StatelessWidget {

  LessonDesc lesson;

  String minorTitle; //= "HOT TRENDING";
  String majorTitle; //= "앞서가는 개발자들이 봐야할 강의들";


  PagingBannerVideoList({this.minorTitle, String lessonId}) {
    lesson = LessonDescManager.singleton().getLessonDesc(lessonId);
    if (lesson != null) {
      majorTitle = lesson.title;
      minorTitle = minorTitle;
    } else {
      majorTitle = '';
      minorTitle = minorTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<LessonDescManager>(builder: (_, model, __) {
      if (lesson != null)
        return categoryCardListView(lesson.videoListEx);
      else
        return Container(height: 230,);
    });
  }

  Widget categoryCardListView(List<LessonVideo> list) {
    final box = Container(
        height: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(minorTitle, style: Styles.sectionText),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(majorTitle, style: Styles.sectionTitle),
            ),
            Container(
              height: 5,
            ),
            Expanded(
                child: Swiper(
                  autoplay: true,
                  viewportFraction: 1.0,
                  itemBuilder: (BuildContext context, int index) {
                    final w = MediaQuery
                        .of(context)
                        .size
                        .width;
                    final h = MediaQuery
                        .of(context)
                        .size
                        .height;

                    return Padding(
                        padding:
                        EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
                        child:
                        VideoBannerCard.page(
                            lesson, list[index], width: w, height: h));
                  },
                  itemCount: list.length,
                  pagination: SwiperPagination(
                      margin: EdgeInsets.only(bottom: 15.0),
                      builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.white,
                          color: Colors.grey,
                          size: 5,
                          activeSize: 8,
                          space: 3.0)),
                ))
          ],
        ));

    return box;
  }

}
