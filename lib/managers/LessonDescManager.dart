import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mydemo_tabnavi2/managers/TestDataLoader.dart';
import 'package:mydemo_tabnavi2/net/DBProxy.dart';

import 'LocalDataLoader.dart';
import '../net/YoutubeApi.dart';
import '../datas/DataTypeDefine.dart';

class LessonDescManager extends DataManager with ChangeNotifier {

  static final LessonDescManager _singleton = new LessonDescManager._internal();

  LessonDescManager._internal();

  factory LessonDescManager.singleton() {
    return _singleton;
  }

  final List<TopicDesc> _topiclist = List<TopicDesc>();
  final List<LessonDesc> _lessonList = List<LessonDesc>();
  final List<ChannelDesc> _channelList = List<ChannelDesc>();

 // final List<VideoDesc> _videoList = List<VideoDesc>();

  LessonDesc getLessonDesc(String lessonId) {
    return  _lessonList.firstWhere((e) => e.lessonId == lessonId, orElse: ()=> null);
  }

  TopicDesc getTopic(String topicId) {
    return _topiclist.firstWhere((e) => e.topicId == topicId, orElse: ()=> null);
  }

  ChannelDesc getChannelDesc(String channelId) {
    try {
      return _channelList.firstWhere((element) =>
      element.channelId == channelId);
    } catch (ex) {
      return null;
    }
  }

  /*
  VideoDesc getVideoDesc(String videoKey) {
    try {
      VideoDesc d = _videoList.firstWhere((e) => e.videoKey == videoKey);
      return d;
    } catch (e) {
      return null;
    }
  }
  */

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
    var iter = _lessonList.where((e) => e.mainTopicId == topicId || e.subTopicId == topicId);
    return iter.toList(growable: false);
  }


  int getLessonCountByTopicId(String topicId) {
    var iter = _lessonList.where((e) => e.mainTopicId == topicId).toList();
    return iter.length;
  }

  List<LessonDesc> queryLessonListBySubTopic(String topicId) {
    var iter = _lessonList.where((e) => e.subTopicId == topicId);
    return iter.toList(growable: false);
  }


  /*
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
*/


  /*
  Future initializeMetaData() async {
    _topiclist.addAll(TestDataLoader.loadTopicList());

    _lessonList.addAll(TestDataLoader.loadLessonList());

    _videoList.addAll(TestDataLoader.loadVideoList());

    await YoutubeDataLoader.singleton().loadVideoDetailInfo(_videoList);

    notifyListeners();
  }
   */
/*
  Future initializeMetaData2() async {
    await Future.delayed(Duration(milliseconds: 0));

    var loader = LocalDataLoader();
    await loader.loadDataSets();

    _topiclist.addAll(loader.topicList);
    _lessonList.addAll(loader.lessonList);
   // _videoList.addAll(loader.videoList);

    notifyListeners();

   // await YoutubeDataLoader.singleton().loadVideoDetailInfo(_videoList);

    notifyListeners();
  }
*/

  Future initializeMetaDataFromServer() async {

    print("initializeMetaDataFromServer begin");

    await loadChannelFromServer();
    await loadTopicFromServer();
    await loadLessonFromServer();

    print("initializeMetaDataFromServer end");

    notifyListeners();

   // await loadYoutubeInfo();
   // await loadChannelInfo();

    notifyListeners();

  }

  /*
  void loadYoutubeInfo() async {
    for(var lesson in _lessonList) {
      await YoutubeApi.singleton().loadVideoDetailInfo(lesson.videoListEx);
    }
  }


  void loadChannelInfo() async {
    for(var lesson in _channelList) {
      if(lesson.channelType == ChannelType.Creator)
        lesson.snippet= await YoutubeApi.singleton().getChannelInfo(lesson.channelId);
    }
  }
*/

  Future<bool> loadChannelFromServer() async {

    Map<String, dynamic> query = {};

    try {

      var jsonResponse = await super.proxy.request('ChannelCollection', DbOpName.find, query);
      List<dynamic> list = jsonDecode(jsonResponse);

      _channelList.clear();

      for (dynamic jsonObj in list) {
        ChannelDesc desc = ChannelDesc.fromJson(jsonObj);
        _channelList.add(desc);
      }

      print("loadChannelFromServer items:" + _channelList.length.toString());
      return true;

    } catch (ex) {
      print('loadChannelFromServer error : ${ex.toString()}');
      return false;
    }
  }

  Future loadTopicFromServer() async {

    Map<String, dynamic> query = {};

    try {

      var jsonResponse = await super.proxy.request('TopicCollection', DbOpName.find, query);
      List<dynamic> list = jsonDecode(jsonResponse);

      _topiclist.clear();

      for (dynamic jsonObj in list) {
        TopicDesc desc = TopicDesc.fromJson(jsonObj);
        _topiclist.add(desc);
      }

      print("loadTopicFromServer items:" + _topiclist.length.toString());
      return true;

    } catch (ex) {
      print('loadTopicFromServer error: ${ex.toString()}');
      return false;
    }
  }

  Future loadLessonFromServer() async {

    //완성된 프로젝트만 로딩한
    var where = {
      'publish' : 2
    };

    Map<String, dynamic> query = {
      'where' : where
    };

    try {

      var jsonResponse = await super.proxy.request('LessonCollection', DbOpName.find, query);
      List<dynamic> list = jsonDecode(jsonResponse);

      _lessonList.clear();

      for (dynamic jsonObj in list) {
        LessonDesc desc = LessonDesc.fromJson(jsonObj);
        _lessonList.add(desc);
      }

      print("loadLessonFromServer items:" + _lessonList.length.toString());
      return true;

    } catch (ex) {
      print('loadLessonFromServer error: ${ex.toString()}');
      return false;
    }
  }

}
