import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mydemo_tabnavi2/common_widgets/cardWidgets.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/common_widgets/widgets.dart';
import 'package:mydemo_tabnavi2/datas/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'lesson_card_widget.dart';
import 'lesson_page.dart';

class TopicPage extends StatefulWidget {
  final TopicDesc desc;
  final TopicData data;

  TopicPage(this.desc)
      : data = LessonDataManager.singleton().getTopicData(desc.topicId) {}

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final Set<LessonLevel> _levelFilter = Set();

  final Set<String> _tagFilter = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3C3C3C),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildFilterChips(context),
              Consumer<LessonDataManager>(builder: (context, model, child) {
                return _buildLessonList(context);
              })
            ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    //final veggie = model.getVeggie(widget.id);

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: Image.asset(
              //desc.imageAssetPath,
              'assets/banner.png',
              fit: BoxFit.cover,
              semanticLabel: 'A background image of ${widget.desc.name}',
            ),
          ),
          Positioned(
            top: 0,
            left: 16,
            child: SafeArea(
              child: IconButton(
                  //size: 30,
                  //bgColor: Colors.white,
                  iconSize: 37,
                  padding: EdgeInsets.all(7),
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
          Positioned(
            top: 0,
            right: 16,
            child: SafeArea(
              child: okSelectableIcon(
                  initSelected: widget.data.favorited,
                  iconSize: 37,
                  iconDataOn: Icons.favorite,
                  iconDataOff: Icons.favorite_border,
                  iconColor: Colors.greenAccent,
                  onChangeState: (bool sel) {
                    widget.data.favorited = sel;
                    // Navigator.of(context).pop();
                  }),
            ),
          ),
          Align(
              alignment: Alignment(0, 0.0),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(children: [
                    Center(
                        child: okCircleImage.color(
                            size: 100,
                            bgColor: Color.fromRGBO(255, 255, 255, 1))),
                    Center(
                        child: okCircleImage.image(
                            size: 95, imagePath: widget.desc.imageAssetPath))
                  ]))),
          Align(
              alignment: Alignment(0, 0.9),
              child: Text(
                widget.desc.name,
                style: Styles.cardTitleText,
              ))
        ],
      ),
    );
  }

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

  Widget _buildFilterChips(BuildContext context) {
    const List<LessonLevel> levels = [
      LessonLevel.Beginnger,
      LessonLevel.Intermediate,
      LessonLevel.Advanced
    ];

    List<okSelectableLabel> levelChips = levels.map<okSelectableLabel>((e) {
      String title;
      if (e == LessonLevel.Beginnger)
        title = "초급";
      else if (e == LessonLevel.Intermediate)
        title = "중급";
      else //if( e == LessonLevel.Advanced)
        title = "고급";

      return okSelectableLabel(title, isLevelFilter(e), (on) {
        onLevelFilter(e, on);
      });
    }).toList();

    var lessonList = LessonDescManager.singleton().queryLessonListByTopic(widget.desc.topicId);
    Set<String> tagSet = Set();
    for(var lesson in lessonList) {
      tagSet.addAll(lesson.tags);
    }

    List<okSelectableLabel> tagChips =
      tagSet.map<okSelectableLabel>((e) {
      Widget c10 = okSelectableLabel(e, _tagFilter.contains(e), (on) {
        onTagFilter(e, on);
      });

      return c10;
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

  bool isFilteredLesson(LessonDesc lessonDesc)
  {
    bool selected = true;

    if( _levelFilter.length !=0 )
      {
        if(!_levelFilter.contains(lessonDesc.level))
          selected = false;
      }

    if( _tagFilter.length !=0 ) {
      if ( _tagFilter.intersection(lessonDesc.tags).length == 0)
        selected = false;
    }

    return selected;
  }

  Widget _buildLessonList(BuildContext context) {
    var lessionModel = LessonDescManager.singleton();

    var lessonList = lessionModel.queryLessonListByTopic(widget.desc.topicId);
    List<Widget> cardList = [];

    for (var lession in lessonList) {
      if ( isFilteredLesson(lession))
        cardList.add(LessonCardWidget(lession));
    }

//
//    widget.
//
//    LessonDesc desc = LessonDesc();
//    desc.title = "샘플 강좌입니다";
//    desc.description = "자바와 관련된 여러가지 강좌를 담았습니다";

    var list = Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 120),
        child: Column(
            // padding: EdgeInsets.all(8.0),
            // shrinkWrap: false,
            children: cardList));

    return list;
  }
}
