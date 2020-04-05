import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mydemo_tabnavi2/datas/DataFuncs.dart';
import 'package:mydemo_tabnavi2/libs/okLocalDatabase.dart';

import '../datas/DataTypeDefine.dart';

typedef RequestCallback = void Function(dynamic result, String err);

class LessonDataManager with ChangeNotifier {
  static final LessonDataManager _singleton = new LessonDataManager._internal();

  LessonDataManager._internal();

  factory LessonDataManager.singleton() {
    return _singleton;
  }

  final List<TopicData> _topicDataList = List();
  final List<LessonData> _lessonDataList = List();
  final List<VideoData> _videoDataList = List();

  TopicData getTopicData(String topicID) {
    try {
      TopicData d = _topicDataList.firstWhere((e) => e.topicId == topicID);
      return d;
    } catch (e) {
      TopicData d = new TopicData(topicID);
      _topicDataList.add(d);
      return d;
    }
  }

  LessonData getLessonData(String lessonID) {
    try {
      LessonData d = _lessonDataList.firstWhere((e) => e.lessonId == lessonID);
      return d;
    } catch (e) {
      LessonData d = new LessonData(lessonID);
      _lessonDataList.add(d);

      return d;
    }
  }


  VideoData getVideoData(String videoKey) {
    try {
      VideoData d = _videoDataList.firstWhere((e) => e.videoKey == videoKey);
      return d;
    } catch (e) {
      VideoData d = new VideoData(videoKey);
      _videoDataList.add(d);
      return d;
    }
  }

  List<LessonData> querySubscribedLessonList() {
    // var list =  _lessonDataList.where((element) => element.subscribed !=null && element.subscribed ).toList(growable: false);

    var list = _lessonDataList
        .where((element) => element.subscribed != null && element.subscribed )
        .toList(growable: false);

    return list;
  }


  List<LessonData> queryActiveLessonList() {
    // var list =  _lessonDataList.where((element) => element.subscribed !=null && element.subscribed ).toList(growable: false);

    var list = _lessonDataList
        .where((element) => element.subscribed != null && element.subscribed && !element.completed)
        .toList(growable: false);

    return list;
  }

  List<LessonData> queryCompletedLessonList() {
    // var list =  _lessonDataList.where((element) => element.subscribed !=null && element.subscribed ).toList(growable: false);

    var list = _lessonDataList
        .where((element) => element.subscribed != null && element.subscribed && element.completed)
        .toList(growable: false);

    return list;
  }

  int queryCompletedVideoCount() {

    int count=0;
    for( var data in _videoDataList) {
      if(data.completed) count++;
    }

    return count;
  }

  void requestLessonCompleted(String lessonId, RequestCallback callback) {
    var data = getLessonData(lessonId);

    if(getLessonCompletedBy(data))
        data.completed = true;

    callback(data, null);
  }

  void requestSubscribeLesson(String lessonId, RequestCallback callback) {
    var data = getLessonData(lessonId);
    data.subscribed = true;

    callback(data, null);
  }

  Future<bool> initLocalPlayDb() async {
    var db = await okLocalDatabase.singleton();

    List<dynamic> topicList = await db.readSection('topic_data');
    List<dynamic> lessonList = await db.readSection('lesson_data');
    List<dynamic> videoList = await db.readSection('video_data');

    _topicDataList.clear();
    _lessonDataList.clear();
    _videoDataList.clear();

    _topicDataList.addAll(topicList.map((e) => TopicData.fromJson(e)).toList());
    _lessonDataList
        .addAll(lessonList.map((e) => LessonData.fromJson(e)).toList());
    _videoDataList.addAll(videoList.map((e) => VideoData.fromJson(e)).toList());

    _lessonDataList.forEach((element) {
      element.subscribed = element.subscribed ?? false;
      element.favorited = element.favorited ?? false;
    });
  }

  Future<bool> commitLocalPlayDb() async {
    var db = await okLocalDatabase.singleton();

    db.updateSection('topic_data', _topicDataList);

    db.updateSection('lesson_data', _lessonDataList);

    db.updateSection('video_data', _videoDataList);
  }
}
