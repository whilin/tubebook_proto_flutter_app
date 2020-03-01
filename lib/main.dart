import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/datas/course_play_model.dart';
import 'package:mydemo_tabnavi2/pages/topic_home_page.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:provider/provider.dart';
import 'datas/course_desc_model.dart';
import 'pages/search_home_page.dart';


void main() {

  LessonDescModel.singleton().initializeMetaData();

  runApp(MultiProvider(
      providers : [
          ChangeNotifierProvider(create: (context) => LessonDescModel.singleton()),
          ChangeNotifierProvider(create: (context) => LessonPlayModel.singleton())
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
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('My Class'),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ]),
          tabBuilder: (context, index) {
            if (index == 0) {
              return TopicsPage();
            } else if (index == 1) {
              return SearchHomePage();
            } else if (index == 2) {
              return Container();
            } else {
              return Container();
            }
          },
        ));
  }
}
