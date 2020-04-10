
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Styles.appBackground,
      body: _buildContent(),
    );
  }

  Widget _buildContent(){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
          Positioned(top:100, right: 0, left: 0, child : _buildTitle()),
          Center(child : _loading()),
          Positioned(bottom:100, right: 0, left: 0, child : _buildTitle()),
      ],
    );
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

  Widget _loading() {

    return SizedBox(
      width: 100,
      height: 100,
        child: Container(
          color: Colors.red,
        )
    );
  }

}