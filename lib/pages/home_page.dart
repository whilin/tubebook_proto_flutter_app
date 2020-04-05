import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/sandbag/topic_page.dart';
import 'package:mydemo_tabnavi2/widgets/cardWidgets.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
import '../widgets/topic_card_widget.dart';
import 'topic_page_ex.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LessonDescManager>(context);

    return Scaffold(
        //appBar: AppBar(title : Text('hello')),
        backgroundColor: Color(0xff3C3C3C),
        body: SafeArea(top : false ,  child : DecoratedBox(
            decoration: BoxDecoration(color: Color(0xff3C3C3C)),
            child: buildList(model))));
  }

  ListView buildList(LessonDescManager model) {
    return ListView(scrollDirection: Axis.vertical, children: [

      PagingBannerSection.section('HotTrend', minorTitle: 'HOT TRENDING'),
      Container(
        height: 20,
      ),
      TopicsSection.section('NativeApp', minorTitle: 'NATIVE APP'),
      Container(
        height: 10,
      ),
      TopicsSection.section('CrossPlatformApp',
          minorTitle: 'CROSS-PLATFORM APP'),
      Container(
        height: 20,
      ),
    ]);
  }
}

class TopicsSection extends StatelessWidget {
  List<TopicDesc> list;

  final String minorTitle; //= "HOT TRENDING";
  //final String majorTitle ;//= "앞서가는 개발자들이 봐야할 강의들";

  TopicsSection.section(String section, {this.minorTitle}) {
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
              child: Text(minorTitle, style: Styles.sectionTitle),
            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 15),
//              child: Text(majorTitle, style: Styles.headlineText),
//            ),
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
          //height: 200,
        ));
  }
}

class PagingBannerSection extends StatelessWidget {
  List<LessonDesc> list;

  final String minorTitle; //= "HOT TRENDING";
  // final String majorTitle ;//= "앞서가는 개발자들이 봐야할 강의들";

  PagingBannerSection.section(String section, {this.minorTitle}) {
    list = LessonDescManager.singleton().queryHotTrends();
  }

  // BannerSection.list(List<TopicDesc> this.list) {}

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
              child: Text(minorTitle, style: Styles.sectionTitle),
            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 15),
//              child: Text(majorTitle, style: Styles.headlineText),
//            ),
            Container(
              height: 5,
            ),
            Expanded(
                child: Swiper(
////              itemHeight: 300,
////              itemWidth: 500,
//              layout: SwiperLayout.STACK,
              autoplay: true,
              viewportFraction: 1.0,
              itemBuilder: (BuildContext context, int index) {
                final w = MediaQuery.of(context).size.width;
                final h = MediaQuery.of(context).size.height;

                return Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
                    child:
                        HotLessonCard.page(list[index], width: w, height: h));
              },
              itemCount: list.length,
              pagination:SwiperPagination(margin: EdgeInsets.only(bottom : 15.0), builder: DotSwiperPaginationBuilder(
                activeColor: Colors.white,
                color : Colors.grey,
                size : 5,
                activeSize: 8,
                space: 3.0
              )),
              //control: SwiperControl(),
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
