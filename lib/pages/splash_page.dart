
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';

import '../styles.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage> {

  int loadintTime =0;
  @override
  void initState() {
    super.initState();

    loadintTime = DateTime.now().millisecondsSinceEpoch;

    LessonDescManager.singleton().addListener(() {
      gotoHome();
    });
  }

  void gotoHome() async {

    int curTime = DateTime.now().millisecondsSinceEpoch;
    int term = curTime - loadintTime;
    if(term < 3000) {
      await Future.delayed(Duration(milliseconds: 3000-term));
    }

    Navigator.of(context).pushNamed('/home');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Styles.appBackground,
      body: _buildContent(),
    );
  }

  Widget _buildContent(){
    return SafeArea(child : Stack(
      alignment: Alignment.center,
      children: <Widget>[
         // Positioned(top:100, right: 0, left: 0, child : _buildTitle()),
          Center(child : _loadLogo()),
          Positioned(bottom: 100,
          child: Text('Data Loading...', style: Styles.font12Text,),)
          //Positioned(bottom:100, right: 0, left: 0, child : _buildTitle()),
      ],
    ));
  }

  Widget _buildTitle() {
    return SizedBox(
     // width: 100,
      height: 50,
      child: Container(
        color: Colors.red,
      )
    );
  }

  Widget _loadLogo() {

    return  Text(
      'My TubeBook',
      style: Styles.font20Text,
    );
  }
}