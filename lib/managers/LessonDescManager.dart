import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mydemo_tabnavi2/managers/TestDataLoader.dart';

import 'LocalDataLoader.dart';
import '../net/YoutubeDataLoader.dart';
import '../datas/DataTypeDefine.dart';

class LessonDescManager with ChangeNotifier {
  static final LessonDescManager _singleton = new LessonDescManager._internal();

  LessonDescManager._internal();

  factory LessonDescManager.singleton() {
    return _singleton;
  }

  final List<TopicDesc> _topiclist = List<TopicDesc>();
  final List<LessonDesc> _lessonList = List<LessonDesc>();
  final List<VideoDesc> _videoList = List<VideoDesc>();


  LessonDesc getLessonDesc(String lessonId) {
    return  _lessonList.firstWhere((e) => e.lessonId == lessonId, orElse: ()=> null);
  }

  TopicDesc getTopic(String topicId) {
    return _topiclist.firstWhere((e) => e.topicId == topicId);
  }

  VideoDesc getVideoDesc(String videoKey) {
    try {
      VideoDesc d = _videoList.firstWhere((e) => e.videoKey == videoKey);
      return d;
    } catch (e) {
      return null;
    }
  }

  List<TopicDesc> getTopicList() {
    return _topiclist;
  }

  List<LessonDesc> queryHotTrends() {
    return _lessonList.getRange(0, min(4, _lessonList.length)).toList();
  }

  List<TopicDesc> getTopicListBySection(String section) {
    return _topiclist.where((e) => e.section == section).toList();
  }

  List<LessonDesc> queryLessonListByTopic(String topicId) {
    var iter = _lessonList.where((e) => e.mainTopicId == topicId);
    return iter.toList(growable: false);
  }

  List<VideoDesc> queryVideoList(List<String> videos) {
    List<VideoDesc> l = new List<VideoDesc>();

    for (var v in videos) {
      var e = _videoList.firstWhere((q) {
        return q.videoKey == v;
      }, orElse: () {
        return null;
      });
      if (e != null) l.add(e);
    }

    return l;
  }



  /*
  Future initializeMetaData() async {
    _topiclist.addAll(TestDataLoader.loadTopicList());

    _lessonList.addAll(TestDataLoader.loadLessonList());

    _videoList.addAll(TestDataLoader.loadVideoList());

    await YoutubeDataLoader.singleton().loadVideoDetailInfo(_videoList);

    notifyListeners();
  }
   */

  Future initializeMetaData2() async {
    await Future.delayed(Duration(milliseconds: 0));

    var loader = LocalDataLoader();
    await loader.loadDataSets();

    _topiclist.addAll(loader.topicList);
    _lessonList.addAll(loader.lessonList);
    _videoList.addAll(loader.videoList);

    notifyListeners();

    await YoutubeDataLoader.singleton().loadVideoDetailInfo(_videoList);

    notifyListeners();
  }
}
