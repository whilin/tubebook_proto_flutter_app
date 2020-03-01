import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/datas/course_data_define.dart';
import 'package:mydemo_tabnavi2/datas/course_desc_model.dart';
import 'package:mydemo_tabnavi2/pages/topic_detail_page.dart';
import 'package:mydemo_tabnavi2/common_widgets/cardWidgets.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class TopicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoTabView(builder: (context) {
      final model = Provider.of<LessonDescModel>(context);

      return DecoratedBox(
          decoration: BoxDecoration(color: Color(0xff3C3C3C)),
          child: SafeArea(child: buildList(model)));
    });
  }

  ListView buildList(LessonDescModel model) {
    return ListView(scrollDirection: Axis.vertical, children: [
      Container(
        height: 100,
        child: Text (
           'My Tube Study',
          style: Styles.cardTitleText,
        ),
      ),
      Container(
        height: 20,
      ),
      TopicsSection.section('NativeApp'),
      Container(
        height: 20,
      ),
      TopicsSection.section('CrossPlatformApp'),
      Container(
        height: 20,
      ),
//      TopicsSection(model.getTopicList()),
//      Container(
//        height: 20,
//      ),
//      TopicsSection(model.getTopicList()),
//      // categoryCardListView(model.getTopicList()),

      //Text("hello")
    ]);
  }
}

class TopicsSection extends StatelessWidget {
  List<TopicDesc> list;

  TopicsSection.section(String section) {
    list = LessonDescModel.singleton().getTopicListBySection(section);
  }

  TopicsSection.list(List<TopicDesc> this.list) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return categoryCardListView(list);
  }

  Widget categoryCardListView(List<TopicDesc> list) {
    final listView = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return buildTopicCard(list[index]);
        });

    final box = SizedBox(
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Mobile App', style: Styles.minorText),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('가장 핫한 모바일 개발 강의 모음', style: Styles.headlineText),
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
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
        child: TopicCard(desc));
  }
}

class TopicCard extends StatelessWidget {
  /// Veggie to be displayed by the card.
  final TopicDesc desc;

  TopicCard(this.desc);

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: () {
        Navigator.of(context).push<void>(CupertinoPageRoute(
          builder: (context) => new TopicDetailPage(desc),
          fullscreenDialog: true,
        ));
      },
      child: Stack(
        children: [
          Semantics(
            label: 'A card background featuring ${desc.name}',
            child: Container(
              width: 250,
              height: 200,
              //height: 200, //isInSeason ? 300 : 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  colorFilter: null,
                  //isInSeason ? null : Styles.desaturatedColorFilter,
                  image: AssetImage(desc.imageAssetPath),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
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
      color: Color(0x90ffffff),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              desc.name,
              style: Styles.font20Text,
            ),
            Text(
              desc.description,
              style: Styles.font15Text,
            ),
          ],
        ),
      ),
    );
  }
}
