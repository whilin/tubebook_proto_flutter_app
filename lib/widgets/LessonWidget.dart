import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';

import '../styles.dart';
import '../pages/LessonCardWidget.dart';
import 'widgets.dart';

/***************************************************
 *
 *
 *
 *
 ***************************************************/

abstract class LessonWidgets {
  static Widget starsWidget(int count) {
    var icons = List<Widget>.generate(count, (index) {
      return Padding(
          padding: EdgeInsets.only(right: 0, left: 0),
          child: Icon(
            Icons.star,
            size: 18,
            color: Colors.greenAccent,
          ));
      ;
    });

    return SizedBox(child: Row(children: icons));
  }

  static Widget buildDescriptor(LessonDesc desc) {
    return new SizedBox(
        // width: 400,
        height: 130,
        child: Stack(children: [
          new Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new okBoxText(
                      text: getLevelName(desc.level),
                      style: Styles.font10Text,
                      bgColor: Colors.amber,
                    ),
                    new Container(
                      width: 5,
                    ),
                    starsWidget(desc.recommanded ?? 0),
                    new Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ))
                  ])),
          new Positioned(
              top: 20,
              left: 0,
              child: Text(
                desc.title,
                style: Styles.font18Text,
              )),
          new Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: Text(
                desc.description,
                // '프로그램을 처음 배우는 사람들을 위해 준비한 강의 입니다.프로그램을 처음 배우는 사람들을 위해 준비한 강의 입니다.',

                overflow: TextOverflow.visible,
                style: Styles.font14Text,
              )),
        ]));
  }

  static Widget buildDescriptorHeader(LessonDesc desc) {
    return new SizedBox(
        // width: 400,
        height: 130,
        child: Stack(
          children: [
            new Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new okBoxText(
                        text: getLevelName(desc.level),
                        style: Styles.font10Text,
                        bgColor: Colors.amber,
                      ),
                      new Container(
                        width: 5,
                      ),
                      starsWidget(desc.recommanded ?? 0),
                      new Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ))
                    ])),
            new Positioned(
                top: 20,
                left: 0,
                child: Text(
                  desc.title,
                  style: Styles.font18Text,
                ))
          ],
        ));
  }

  static Widget buildCreator(String channelId) {
    var channelDesc = LessonDescManager.singleton().getChannelDesc(channelId);

    if (channelDesc == null) {
      return new SizedBox(width: 300, height: 60);
    } else  {
      return new SizedBox(
          width: 300,
          height: 60,
          child: Stack(children: [
            new Positioned(
              top: 0,
              left: 0,
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                channelDesc.snippet !=null ? NetworkImage(channelDesc.snippet.getThumnail(level: 0))
                    : AssetImage('assets/images/person-placeholder.jpg'),
              ),
            ),
            new Positioned(
              top: 15,
              left: 70,
              child: okBoxLineText(
                text: channelDesc.channelType == ChannelType.Creator ? "CREATOR" : 'CURATOR',
                style: Styles.font10Text,
              ),
            ),
            new Positioned(
              top: 35,
              left: 70,
              child: Text(
                channelDesc.name,
                style: Styles.font10Text,
              ),
            ),
          ]));
    }
  }

  /*
  static Widget buildCreatorLabel(String channelId) {
    return new SizedBox(
        width: 200,
        height: 60,
        child: Stack(children: [
          new Positioned(
            top: 0,
            left: 0,
            child: okBoxLineText(
              text: "CREATOR",
              style: Styles.font10Text,
            ),
          ),
          new Positioned(
            top: 20,
            left: 0,
            child: Text(
              "코딩파파",
              style: Styles.font10Text,
            ),
          ),
        ]));
  }
*/

  static Widget buildCuratorLabel(String channelId) {

    var channelDesc = LessonDescManager.singleton().getChannelDesc(channelId);

    if(channelDesc ==null )
      return Container(
        width: 200,
        height: 60,
      );
    else
      return new SizedBox(
        width: 200,
        height: 60,
        child: Stack(children: [
          new Positioned(
            top: 0,
            left: 0,
            child: okBoxLineText(
              text: channelDesc.channelType == ChannelType.Creator ?'CREATOR' : 'CURATOR',
              style: Styles.font10Text,
            ),
          ),
          new Positioned(
            top: 20,
            left: 0,
            child: Text(
              channelDesc.name,
              style: Styles.font10Text,
            ),
          ),
        ]));
  }
}
