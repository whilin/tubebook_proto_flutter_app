import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/pages/myprofile_header.dart';

import '../styles.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildLogonState(),
          Container(height: 20),
          _buildSettingLine()
        ],
      ),
    );
  }

  Widget _buildLogonState() {
    return Column(
      children: <Widget>[
        new MyProfileHeader(),
        Container(height: 20),
        _buildRButton(
            width: 170,
            height: 34,
            bgColor: Color(0xff37A000),
            text: Text(
              '로그아웃',
              style: Styles.font15Text,
            ))
      ],
    );
  }

  Widget _buildRButton(
      {double width, double height, Color bgColor, Text text}) {
    return new GestureDetector(
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: bgColor),
        child: text,
      ),
      onTap: () {},
    );
  }

  Widget _buildSettingLine(){
    return new Padding(padding: EdgeInsets.symmetric(horizontal: 40)  , child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('설정', style: Styles.font16Text, textAlign: TextAlign.start),
        Divider(thickness: 1, color: Colors.grey,),
        _buildOnOffItem('강의 연속 재생', false, (newValue){}),
        _buildOnOffItem('WI-FI 에서만 재생', false, (newValue){}),
        _buildInfoItem('앱 버전', 'v0.1.0')

      ],
    ));
  }

  Widget _buildOnOffItem(String title, bool initValue, void Function(bool) onChanged) {
    return Row(
        //alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: Styles.font16Text,),
          Expanded(flex: 1,child: Container(),),
          Switch(value: initValue,
              onChanged: (newValue) {
                onChanged(newValue);
              }
          )
        ]);
  }
  Widget _buildInfoItem(String title, String initValue) {
    return Row(
      //alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: Styles.font16Text,),
          Expanded(flex: 1,child: Container(),),
          Text(initValue,style: Styles.font16Text,)
    ]);
  }

}
