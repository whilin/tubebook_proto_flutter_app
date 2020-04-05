import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
import 'topic_page_ex.dart';

class SearchPage extends StatelessWidget {

  void onClickTopic(BuildContext context, TopicDesc desc) {
      Navigator.of(context).push<void>(CupertinoPageRoute(
        builder: (context) => new TopicPageEx(desc),
        fullscreenDialog: false,
      ));
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
        backgroundColor: Styles.appBackground,
        appBar: AppBar(
          title: _buildSearchBar(),
          backgroundColor: Styles.appBackground,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        //_buildSearchBar(),
                        Container(
                          height: 20,
                        ),
                        _buildSectionTitle('Hot Keywords'),
                        _buildKeywordChips(context),
                        Container(
                          height: 40,
                        ),

                        _buildSection(context, 'NativeApp'),
                        Container(
                          height: 20,
                        ),
                        _buildSection(context, 'CrossPlatformApp'),
                        Container(
                          height: 20,
                        ),
                        _buildSection(context, 'Web'),
                        Container(
                          height: 20,
                        ),
                        _buildSection(context, 'A•I')

                        //_buildSubSectionTitle('Android App Development')
                      ],
                    )))));
  }

  Widget _buildSearchBar() {
    return SizedBox(
        height:80,
        child: SearchBar(
          searchBarStyle: SearchBarStyle(
            backgroundColor: Colors.black12,
            padding: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(40),
          ),
        ));
  }

  Widget _buildSection(BuildContext context, String section) {

    var topicList =
        LessonDescManager.singleton().getTopicListBySection(section);

    var items = topicList.map((e) {
      return _buildTopicItem(context, e);
    }).toList();

    return Column(
      children: <Widget>[
        _buildSectionTitle('◼︎ For ${section} developer'),
        ...items
      ],
    );
  }

  static Widget _buildSectionTitle(String text) {
    return SizedBox(
      //height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: Styles.font16Text,
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context, TopicDesc desc) {
    return GestureDetector(
        onTap: () {
          onClickTopic(context, desc);
        },
        child: Container(
          padding: EdgeInsets.only(left: 50),
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                Text(
                  desc.name,
                  style: Styles.font16Text,
                ),
                Expanded(flex: 1, child: Container()),
                Text(
                  '3개 강좌',
                  style: Styles.font16Text,
                )
              ]),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ));
  }

  Widget _buildKeywordChips(BuildContext context) {
    return _buildFilterChipsEx(context);
  }

  Widget _buildFilterChipsEx(BuildContext context) {
    List<Widget> levelChips = LessonLevel.values.map<Widget>((e) {
      String title = getLevelName(e);

      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: FilterChip(
              label: Text(title),
              selectedColor: Colors.greenAccent,
              selected: false, //isLevelFilter(e),
              onSelected: (on) {
                //onLevelFilter(e, on);
              }));
    }).toList();
//
//    var firstList = Wrap SizedBox(
//        height: 35,
//        child: ListView(
//            shrinkWrap: true,
//            scrollDirection: Axis.horizontal,
//            children: levelChips));

    return SizedBox(
      //height: 35,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: levelChips,
            ),
            // Expanded(child:Row(children: firstLine))
            // Row(children : firstLine)
          ]),
    );
  }
}
