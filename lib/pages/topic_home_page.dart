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
          decoration: BoxDecoration(color: Color(0xffffffff)),
          child: Stack(children: [
            // SearchBar(),
            categoryCardListView(model.getTopicList())
          ]));
    });
  }

  Widget categoryCardListView(List<TopicDesc> list) {
    final listView = ListView.builder(
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1월", style: Styles.minorText),
                  Text('In season today', style: Styles.headlineText),
                ],
              ),
            );
          } else if (index > 0) {
            return buildTopicCard(list[index - 1]);
          }
        });

    return listView;
  }

  /*
  Widget buildCateCard(CategoryDesc desc) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: FutureBuilder<Set<VeggieCategory>>(
          future: prefs.preferredCategories,
          builder: (context, snapshot) {
            final data = snapshot.data ?? Set<VeggieCategory>();
            return CategoryCard(desc);
          }),
    );
  }
  */

  Widget buildTopicCard(TopicDesc desc) {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
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
              height: 300, //isInSeason ? 300 : 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.scaleDown,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              desc.name,
              style: Styles.cardTitleText,
            ),
            Text(
              "여러가지 설명",
              style: Styles.cardDescriptionText,
            ),
          ],
        ),
      ),
    );
  }
}
