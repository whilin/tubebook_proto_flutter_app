import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/datas/course_play_model.dart';
import 'package:mydemo_tabnavi2/pages/topic_home_page.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:provider/provider.dart';
import 'datas/course_desc_model.dart';


void main() {

  LessonDescModel.singleton().initializeMetaData();

  runApp(MultiProvider(
      providers : [
          ChangeNotifierProvider(builder: (context) => LessonDescModel.singleton()),
          ChangeNotifierProvider(builder: (context) => LessonPlayModel.singleton())
        ],
      child : MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        color: Styles.appBackground,
        home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              title: Text('Topics'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              title: Text('My Class'),
            ),

            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              title: Text('Settings'),
            ),
          ]),
          tabBuilder: (context, index) {
            if (index == 0) {
              return TopicsPage();
            } else if (index == 1) {
              return Container();
            } else if (index == 2) {
              return Container();
            } else {
              return Container();
            }
          },
        ));
  }
}
