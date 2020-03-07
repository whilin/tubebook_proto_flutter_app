import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mydemo_tabnavi2/libs/okLocalDatabase.dart';

import 'DataTypeDefine.dart';


class LessonDataManager with ChangeNotifier {

  static final LessonDataManager _singleton = new LessonDataManager._internal();

  LessonDataManager._internal();

  factory LessonDataManager.singleton() {
    return _singleton;
  }

  final List<TopicData> _topicDataList =  List();
  final List<LessonData> _lessonDataList = List();
  final List<VideoData> _videoDataList = List();

  TopicData getTopicData(String topicID)
  {
    try {

      TopicData d = _topicDataList.firstWhere((e) => e.topicId == topicID);
      return d;

    }  catch(e) {
      TopicData d = new TopicData(topicID);
      _topicDataList.add(d);
      return d;
    }
  }

  LessonData getLessonData(String lessonID)
  {
    try {

      LessonData d = _lessonDataList.firstWhere((e) => e.lessonId == lessonID);
      return d;

    }  catch(e) {

      LessonData d = new LessonData(lessonID);
      _lessonDataList.add(d);

      return d;
    }
  }


  VideoData getVideoData(String videoKey)
  {
    try {

      VideoData d = _videoDataList.firstWhere((e) => e.videoKey == videoKey);
      return d;

    }  catch(e) {
      VideoData d = new VideoData(videoKey);
      _videoDataList.add(d);
      return d;
    }
  }

  Future<bool> initLocalPlayDb() async {
    var db = await okLocalDatabase.singleton();

    List<dynamic> topicList = await db.readSection('topic_data');
    List<dynamic> lessonList = await db.readSection('lesson_data');
    List<dynamic> videoList = await db.readSection('video_data');

    _topicDataList.clear();
    _lessonDataList.clear();
    _videoDataList.clear();

    _topicDataList.addAll(topicList.map((e)=> TopicData.fromJson(e)).toList());
    _lessonDataList.addAll(lessonList.map((e)=> LessonData.fromJson(e)).toList());
    _videoDataList.addAll(videoList.map((e)=> VideoData.fromJson(e)).toList());
  }

  Future<bool> commitLocalPlayDb() async {

    var db = await okLocalDatabase.singleton();

    db.updateSection('topic_data', _topicDataList);

    db.updateSection('lesson_data', _lessonDataList);

    db.updateSection('video_data', _videoDataList);
  }
}