import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydemo_tabnavi2/pages/splash_page.dart';
import 'managers/LessonDataManager.dart';
import 'pages/home_page.dart';
import 'package:mydemo_tabnavi2/styles.dart';
import 'package:provider/provider.dart';
import 'managers/LessonDescManager.dart';
import 'pages/more_page.dart';
import 'pages/myclass_page.dart';
import 'sandbag/post_title_bar_page.dart';
import 'pages/search_page.dart';
import 'sandbag/sliver_app_bar_page.dart';


void main() {

  //LessonDescManager.singleton().initializeMetaData2();
  LessonDescManager.singleton().initializeMetaDataFromServer();

  LessonDataManager.singleton().initLocalPlayDb();

//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    systemNavigationBarColor: Colors.blue, // navigation bar color
//    statusBarColor: Colors.pink, // status bar color
//  ));

  runApp(MultiProvider(
      providers : [
          ChangeNotifierProvider(create: (context) => LessonDescManager.singleton()),
          ChangeNotifierProvider(create: (context) => LessonDataManager.singleton())
        ],
      child : MyMaterialApp()));
}

/*
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
 */

final routes = {
  '/splash' : (BuildContext context) => SplashPage(),
  '/home' : (BuildContext context) => MyMaterialAppHome(title: 'MyTubeBook'),
};


class MyMaterialApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTubeBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.yellow
      ),

      initialRoute: '/splash',
      routes: routes

      //home: MyMaterialAppHome(title: 'MyTubeBook'),
    );
  }
}


//TabView에 대한 튜토리얼
//https://medium.com/flutter/getting-to-the-bottom-of-navigation-in-flutter-b3e440b9386

class MyMaterialAppHome extends StatefulWidget {
  MyMaterialAppHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyMaterialAppHomeState createState() => _MyMaterialAppHomeState();
}

class _MyMaterialAppHomeState extends State<MyMaterialAppHome>
    with SingleTickerProviderStateMixin,  WidgetsBindingObserver {

  int _selectedIndex = 0;

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState > '+state.toString());

    if(state == AppLifecycleState.resumed){
      // user returned to our app
    }else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
      LessonDataManager.singleton().commitLocalPlayDb();

    }else if(state == AppLifecycleState.inactive){
      // app is inactive
    }else if(state == AppLifecycleState.detached){
      // app suspended (not used in iOS)
    }
  }
  @override
  Widget build(BuildContext context) {
    return buildMain(context);
  }


  Widget buildMain(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.black38,
          currentIndex: _selectedIndex,
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text('Search'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                title: Text('My Class')),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text('More'))

          ],
          onTap: (index) {
            onTabTapped(index);
          },
        ),
        body: IndexedStack(
            index: _selectedIndex,
            children:  [
              HomePage(),
              SearchPage(),
              MyClassPage(),
              MorePage(),
            ])
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}