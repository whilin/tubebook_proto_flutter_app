import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/managers/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/pages/LessonCardWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles.dart';
import 'LessonProgressBarWidget.dart';
import 'lesson_page.dart';
import 'myprofile_header.dart';

class MyClassPage extends StatefulWidget {
  @override
  _MyClassPageState createState() => _MyClassPageState();
}

class _MyClassPageState extends State<MyClassPage>
    with TickerProviderStateMixin {
  int _selectedPage = 0;

  List<LessonData> _activeDataList;
  List<LessonDesc> _activeDescList;

  List<LessonDesc> _completedDescList;
  List<LessonData> _completedDataList;

  void _showLessonPage(LessonDesc desc) {
    var data = LessonDataManager.singleton().getLessonData(desc.lessonId);

    showCupertinoModalPopup<LessonPage>(
        context: context,
        builder: (context) => LessonPage(desc: desc, data: data));
  }

  void initState() {
    super.initState();
    refreshActiveLessonList();
  }

  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
    refreshActiveLessonList();
  }

  void refreshActiveLessonList() {
    _activeDataList = LessonDataManager.singleton().queryActiveLessonList();
    _activeDescList = _activeDataList
        .map<LessonDesc>(
            (e) => LessonDescManager.singleton().getLessonDesc(e.lessonId))
        .toList();

    _completedDataList = LessonDataManager.singleton().queryCompletedLessonList();
    _completedDescList = _completedDataList
        .map<LessonDesc>(
            (e) => LessonDescManager.singleton().getLessonDesc(e.lessonId))
        .toList();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff3C3C3C),
        body: CustomScrollView(slivers: <Widget>[
//        SliverPersistentHeader(
//          pinned: true,
//          floating: false,
//          delegate: MyClassSliverAppBar(expandedHeight: 320),
//        ),
          SliverList(
              delegate: SliverChildListDelegate([
            //MyProfileHeader(),
            //Container(height: 20),
            _MyClassHeader2(),
            Container(
              height: 20,
            ),
            _buildTab(),
          ])),

          _buildSelectedTabPage()
        ]));
  }

  Widget _buildTab() {
    return TabBar(
        controller: new TabController(
            length: 3, vsync: this, initialIndex: _selectedPage),
        tabs: [
          Tab(text: '진행중인 레슨'), //, icon:  Icon(Icons.directions_car)),
          Tab(text: '완료한 레슨'), //icon: Icon(Icons.directions_transit)),
          Tab(text: '찜리스트'), //icon: Icon(Icons.directions_bike)),
        ],
        onTap: (page) {
          setState(() {
            _selectedPage = page;
          });
        });
  }

  SliverList _buildSelectedTabPage() {
    List<Widget> list;
    if (_selectedPage == 0) {
      list = _buildActiveLessons(_activeDescList);
    } else if (_selectedPage == 1) {
      list = _buildActiveLessons(_completedDescList);
    } else if (_selectedPage == 2) {
      list = _buildFavLesson();
    }

    return SliverList(delegate: SliverChildListDelegate(list));
  }

  List<Widget> _buildActiveLessons(List<LessonDesc> descList) {
    var width = MediaQuery.of(context).size.width;

    var list = descList.map((e) {
      return new Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: SizedBox(
              width: width,
              height: 110,
              child: Stack(children: [
                LessonProgressBarWidget.forMyClass(
                    desc: e,
                    onBarClick: () {
                      _showLessonPage(e);
                    },
                    onSubscribeClick: () {
                      //Nothing TODO!
                    }),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child : Divider(color: Colors.black54,))
              ])));
    }).toList();

    list.insert(0, Container(height: 20));
    return list;
  }


  List<Widget> _buildFavLesson() {
    return [Container()];
  }
}

/*
class MyClassPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff3C3C3C),
        body: SingleChildScrollView(
            child: Column(children: [
          _MyClassHeader1(),
          Container(
            height: 20,
          ),
          _MyClassHeader2(),
          Container(
            height: 20,
          ),
          _MyClassTabList()
        ])));
  }
}
*/

class MyClassSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MyClassSliverAppBar({@required this.expandedHeight});

  double getOpacity(double shrinkOffset) {
    var offset = expandedHeight - 80;
    var v = (1 - shrinkOffset / offset);
    return v.clamp(0, 1);
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(children: [
      MyProfileHeader(),
      _MyClassHeader2(),
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}


class _MyClassHeader2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int subscribedLessons = LessonDataManager.singleton().querySubscribedLessonList().length;
    int completedLessons = LessonDataManager.singleton().queryCompletedLessonList().length;
    int completedVideos =LessonDataManager.singleton().queryCompletedVideoCount();

    return SafeArea(
        top: true,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          //color: Colors.amber,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: getItem(subscribedLessons, "subscribed\nlessons")),
              getDivider(),
              Expanded(child: getItem(completedLessons, "completed\nlessons")),
              getDivider(),
              Expanded(child: getItem(completedVideos, "completed\nvideos"))
            ],
          ),
        )));
  }

  Widget getItem(int num, String title) {
    return Container(
        height: 100,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(num.toString(), style: Styles.font30Text)),
          Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(title,
                  textAlign: TextAlign.center, style: Styles.font12Text))
        ]));
  }

  Widget getDivider() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: VerticalDivider(
          color: Colors.black,
        ));
  }
}

class _MyClassTabList extends StatefulWidget {
  //TabController _controller;

  _MyClassTabList() {
    // _controller = new TabController(length: 3, vsync: true);
  }

  @override
  __MyClassTabListState createState() => __MyClassTabListState();
}

/*
class __MyClassTabListState extends State<_MyClassTabList> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 3,
        initialIndex: _selectedPage,
        child: Column(children: [
          TabBar(
            tabs: [
              Tab(text: '진행중인 레슨'), //, icon: Icon(Icons.directions_car)),
              Tab(text: '왼료된 레슨'), //icon: Icon(Icons.directions_transit)),
              Tab(text: '찜리스트'), //icon: Icon(Icons.directions_bike)),
            ],
            onTap: (index) {
              setState(() {
                _selectedPage = index;
              });
            },
          ),
          IndexedStack(
            index: _selectedPage,
            children: <Widget>[
              _buildLessonType1(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          )
//          TabBarView(
//            children: <Widget>[
//              Tab(child:  Icon(Icons.directions_car)),
//              Tab(child: Icon(Icons.directions_transit)),
//              Tab(child: Icon(Icons.directions_bike)),
//            ],
//          )
        ]));
  }

  Widget _buildLessonType1() {
    return Center(child: Icon(Icons.directions_car));
  }
}
*/

class __MyClassTabListState extends State<_MyClassTabList>
    with TickerProviderStateMixin {
  int _selectedPage = 0;
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        new TabController(length: 3, initialIndex: _selectedPage, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      TabBar(
        controller: _controller,
        tabs: [
          Tab(text: '진행중인 레슨'), //, icon:  Icon(Icons.directions_car)),
          Tab(text: '완료한 레슨'), //icon: Icon(Icons.directions_transit)),
          Tab(text: '찜리스트'), //icon: Icon(Icons.directions_bike)),
        ],
//            onTap: (index) {
//              setState(() {
//                _selectedPage = index;
//              });
//            },
      ),
      Container(
          height: 3000,
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              _MyLessonList(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ))
    ]);
  }

  Widget _buildLessonType1() {
    return Center(child: Icon(Icons.directions_car));
  }
}

/*
class __MyClassTabListState extends State<_MyClassTabList> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 3,
        initialIndex: _selectedPage,
        child: Scaffold(
            appBar: new AppBar(
                bottom: TabBar(tabs: [
              Tab(text: '진행중인 레슨'),
              //, icon: Icon(Icons.directions_car)),
              Tab(text: '왼료된 레슨'),
              //icon: Icon(Icons.directions_transit)),
              Tab(text: '찜리스트'),
              //icon: Icon(Icons.directions_bike)),
            ])),
            body: TabBarView(
              children: <Widget>[
                Tab(child: Icon(Icons.directions_car)),
                Tab(child: Icon(Icons.directions_transit)),
                Tab(child: Icon(Icons.directions_bike)),
              ],
            )));
  }

  Widget _buildLessonType1() {
    return Center(child: Icon(Icons.directions_car));
  }
}
*/

class _MyLessonList extends StatefulWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new ListView.builder(
//      itemBuilder: (context, index) {
//        return ListTile( title: Text('test $index'));
//      }
//    );
//  }

  @override
  __MyLessonListState createState() => __MyLessonListState();
}

class __MyLessonListState extends State<_MyLessonList> {
  List<LessonData> _sortedDataList;
  List<LessonDesc> _sortedDescList;

  @override
  void initState() {
    super.initState();
    buildList();
  }

  @override
  void didUpdateWidget(_MyLessonList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    buildList();
  }

  void buildList() {
    _sortedDataList = LessonDataManager.singleton().querySubscribedLessonList();
    _sortedDescList = _sortedDataList
        .map<LessonDesc>(
            (e) => LessonDescManager.singleton().getLessonDesc(e.lessonId))
        .toList();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return new Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: _sortedDescList
          .map<Widget>((desc) => new Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: SizedBox(
                  width: size.width,
                  child: LessonProgressBarWidget.forMyClass(
                      desc: desc,
                      onBarClick: () {
                        _showLessonPage(desc);
                      },
                      onSubscribeClick: () {
                        //Nothing TODO!
                      }))))
          .toList(),
    );
  }

  void _showLessonPage(LessonDesc desc) {
    var data = LessonDataManager.singleton().getLessonData(desc.lessonId);

    showCupertinoModalPopup<LessonPage>(
        context: context,
        builder: (context) => LessonPage(desc: desc, data: data));
  }

/*
    return new Column(
     // mainAxisAlignment: MainAxisAlignment.center,
      children: _sortedDescList
          .map<Widget>((e) => new Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: LessonCardDetailBarWidget.forMyClass(e)))
          .toList(),
    );
*/
/*
    return new ListView.builder(
        itemCount: _sortedDescList.length,
        itemBuilder: (context, index) {
          return new Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child:
                  LessonCardDetailBarWidget.forMyClass(_sortedDescList[index]));
        });
  }
 */
}
