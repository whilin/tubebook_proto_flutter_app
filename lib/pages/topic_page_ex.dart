import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mydemo_tabnavi2/managers/AssetsManager.dart';
import 'package:mydemo_tabnavi2/widgets/LessonWidget.dart';
import 'package:mydemo_tabnavi2/widgets/cardWidgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/widgets/widgets.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/libs/okUtils.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:mydemo_tabnavi2/widgets/filter_action_button.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'LessonCardWidget.dart';
import 'lesson_page.dart';

class TopicPageEx extends StatefulWidget {
  final TopicDesc desc;
  final TopicData data;

  TopicPageEx(this.desc)
      : data = LessonDataManager.singleton().getTopicData(desc.topicId) {}

  @override
  _TopicPageStateEx createState() => _TopicPageStateEx();
}

class _TopicPageStateEx extends State<TopicPageEx> {
  final Set<LessonLevel> _levelFilter = Set();

  final Set<String> _tagFilter = Set();


  void onLevelFilter(LessonLevel level, bool on) {
    setState(() {
      if (on)
        _levelFilter.add(level);
      else
        _levelFilter.remove(level);
    });
  }

  bool isLevelFilter(LessonLevel level) {
    return _levelFilter.contains(level);
  }

  void onTagFilter(String tag, bool on) {
    setState(() {
      if (on)
        _tagFilter.add(tag);
      else
        _tagFilter.remove(tag);
    });
  }

  bool isFilteredLesson(LessonDesc lessonDesc) {
    bool selected = true;

    if (_levelFilter.length != 0) {
      if (!_levelFilter.contains(lessonDesc.level)) selected = false;
    }

    if (_tagFilter.length != 0) {
      if (_tagFilter.intersection(lessonDesc.tags).length == 0)
        selected = false;
    }

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3C3C3C),
      body: CustomScrollView(slivers: <Widget>[
        SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: TopicSliverAppBar(expandedHeight: 200, desc: widget.desc),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0)
              return Container(height: 20);
            else if (index == 1)
              // return _buildFilterChipsEx(context);
              return Container();
            else if (index == 2)
              return Container(height: 20);
            else if (index == 3)
              return _buildLessonList(context);
            else
              return null;
          }),
        )
      ]),
    );
  }

  Widget _buildFilterChipsEx(BuildContext context) {
    List<Widget> levelChips = LessonLevel.values.map<Widget>((e) {
      String title = getLevelName(e);

      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: FilterChip(
              label: Text(title),
              selectedColor: Colors.greenAccent,
              selected: isLevelFilter(e),
              onSelected: (on) {
                onLevelFilter(e, on);
              }));
    }).toList();

    var lessonList = LessonDescManager.singleton()
        .queryLessonListByTopic(widget.desc.topicId);

    Set<String> tagSet = Set();
    for (var lesson in lessonList) {
      tagSet.addAll(lesson.tags);
    }

    List<Widget> tagChips = tagSet.map<Widget>((e) {
      Widget c = FilterChip(
          label: Text(e),
          selectedColor: Colors.greenAccent,
          selected: _tagFilter.contains(e),
          onSelected: (on) {
            onTagFilter(e, on);
          });

      return Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: c);
    }).toList();

    var firstList = SizedBox(
        height: 35,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: levelChips));

    var secondList = SizedBox(
        height: 35,
        child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: tagChips));

    //firstLine.add(c1);

    return SizedBox(
      height: 70,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        firstList,
        secondList
        // Expanded(child:Row(children: firstLine))
        // Row(children : firstLine)
      ]),
    );
  }

  Widget _buildLessonList(BuildContext context) {
    var lessionModel = LessonDescManager.singleton();

    var lessonList = lessionModel.queryLessonListByTopic(widget.desc.topicId);
    List<Widget> cardList = [];

    int i = 0;
    for (var lession in lessonList) {
      if (isFilteredLesson(lession)) {
        cardList.add(LessonCardWidget(lession, listItemIndex: i++));
      }
    }

    var padding = Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 120),
        child: Column(
            // padding: EdgeInsets.all(8.0),
            // shrinkWrap: false,
            children: cardList));

    return padding;
  }

}

class TopicSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final TopicDesc desc;

  TopicSliverAppBar({@required this.expandedHeight, this.desc});

  double getOpacity(double shrinkOffset) {
    var offset = expandedHeight - 80;
    var v = (1 - shrinkOffset / offset);
    return max(0, min(1, v));
  }

  void _onClosePage(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(fit: StackFit.expand, overflow: Overflow.visible, children: [
      ClipPath(
          clipper: _DialogonalClipper(),
          child: Image.asset(getImageAssetFile('logo_flutter_2.jpg'),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.srcOver,
              color: Colors.black12)),
      Positioned(
        left: 10,
        top: 32,
        child: Opacity(
            opacity: getOpacity(shrinkOffset),
            child: IconButton(
                //size: 30,
                //bgColor: Colors.white,
                iconSize: 37,
                padding: EdgeInsets.all(7),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  _onClosePage(context);
                })),
      ),
      Positioned(
          bottom: 0,
          left: 20,
          child: Hero(
              tag: desc.topicId,
              child: new Opacity(
                  opacity: getOpacity(shrinkOffset),
                  child: new CircleAvatar(
                        radius: 50,
                      backgroundImage: AssetsManager.getTopicLogo(desc.topicId))))),
                      //size: 100,
                     // imagePath: getTopicLogoAsset(desc.topicId))))),
      Positioned(
          bottom: 50,
          left: 130,
          right: 10,
          child: Opacity(
              opacity: getOpacity(shrinkOffset),
              child: Text(
                desc.name,
                //'자바 개발자가 되는 길',
                style: Styles.font18Text,
                overflow: TextOverflow.ellipsis,
              ))),
      Positioned(
          bottom: -15,
          left: 130,
          child: Opacity(
              opacity: getOpacity(shrinkOffset),
              child: LessonWidgets.buildCuratorLabel(desc.channelId))),
      Positioned(
          bottom: -70,
          right: -50,
          child: Opacity(
            opacity: getOpacity(shrinkOffset),
            child: new FilterActionButton(onSelected: (int id) {}),
          )),
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, 150); //size.height* 0.75);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
