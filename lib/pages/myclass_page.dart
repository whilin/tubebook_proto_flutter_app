import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/datas/LessonDataManager.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/widgets/lesson_card_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles.dart';
import 'lesson_page.dart';


class MyClassPage extends StatelessWidget {
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
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0)
              return _MyClassHeader1();
            else if (index == 1)
              return Container(
                height: 20,
              );
            else if (index == 2)
              return _MyClassHeader2();
            else if (index == 3)
              return Container(
                height: 20,
              );
            else if (index == 4)
              return _MyClassTabList();
            else
              return null;
          }),
        )
      ]),
    );
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
    return Column( children: [
      _MyClassHeader1(),
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

class _MyClassHeader1 extends StatefulWidget {
  @override
  __MyClassHeader1State createState() => __MyClassHeader1State();
}

class __MyClassHeader1State extends State<_MyClassHeader1> {
  ImageProvider _myPhotoProvier;

  String _myName = '';

  void initState() {
    super.initState();
    _myPhotoProvier = AssetImage('assets/images/person-placeholder.jpg');
    loadSavedProfilePhoto();
  }

  //File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024);

    var imageBytes = await image.readAsBytes();
    final directory = await getApplicationDocumentsDirectory();
    var photoFile = File('${directory.path}/profile_photo.jpg');
    await photoFile.writeAsBytes(imageBytes);

    setState(() {
      //_image = image;
      _myPhotoProvier = FileImage(image);
    });
  }

  Future loadSavedProfilePhoto() async {
    final directory = await getApplicationDocumentsDirectory();
    var photoFile = File('${directory.path}/profile_photo.jpg');

    if (await photoFile.exists()) {
      setState(() {
        _myPhotoProvier = FileImage(photoFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        top: true,
        child: Container(
            // height: 100,
            //color: Colors.red,
            child: Column(
          children: <Widget>[
            GestureDetector(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _myPhotoProvier,
                ),
                onTap: () {
                  getImage();
                }),
            //Text('_____', style: Styles.font20Text),
            _buildInputName(),
          ],
        )));
  }

  Widget _buildInputName() {
    return SizedBox(
        width: 200,
        child: Stack(
           // alignment: Alignment.bottomCenter,
            children: [
          TextField(
              textAlignVertical : TextAlignVertical.bottom,
              textAlign: TextAlign.center,
              style: Styles.font20Text,
              controller: TextEditingController(text: _myName),
              onTap: () {},
              onSubmitted: (text) {
                setState(() {
                  _myName = text;
                });
              }),
          //Divider(),
        ]));
  }
}

class _MyClassHeader2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int subscribedLessons =
        23; // LessonDataManager.singleton().querySubscribedLessons();
    int completedLessons =
        15; // LessonDataManager.singleton().queryCompletedLessons();
    int completedVideos =
        35; //LessonDataManager.singleton().queryCompletedVideos();

    return Padding(
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
        ));
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
          Tab(text: '왼료된 레슨'), //icon: Icon(Icons.directions_transit)),
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
    final size = MediaQuery
        .of(context)
        .size;

    return new Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: _sortedDescList
          .map<Widget>((desc) =>
      new Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child:
          SizedBox(
              width: size.width,
              child: LessonCardDetailBarWidget.forMyClass(desc: desc,
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
        builder: (context) =>
            LessonPage(desc: desc, data: data));
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
