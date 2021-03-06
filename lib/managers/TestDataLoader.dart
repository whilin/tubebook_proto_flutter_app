import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../net/YoutubeApi.dart';
import 'package:youtube_api/youtube_api.dart';
import '../datas/DataTypeDefine.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/_api.dart';

class TestDataLoader {

  //..
  //..
  /*
  static List<TopicDesc> loadTopicList() {
    List<TopicDesc> _topiclist = new List<TopicDesc>();

    TopicDesc desc;

    desc = TopicDesc()
      ..topicId = 'topic_flutter'
      ..name = 'Flutter'
      ..section = 'CrossPlatformApp'
      ..imageAssetPath = 'assets/logo_flutter.png'
      ..description = 'Google에서 만든 CrossPlatorm'
      ..tags = ['Widget', 'Async', 'Database', 'Networking'];
    _topiclist.add(desc);

    desc = TopicDesc()
      ..topicId = 'swift_topic'
      ..name = 'Swift'
      ..section = 'NativeApp'
      ..imageAssetPath = 'assets/title_swift.jpg'
      ..description = 'Google에서 만든 CrossPlatorm'
      ..tags = [];
    _topiclist.add(desc);

    desc = TopicDesc()
      ..topicId = 'android_topic'
      ..name = 'Android'
      ..section = 'NativeApp'
      ..imageAssetPath = "assets/title_android.png"
      ..description = 'Google에서 만든 CrossPlatorm'
      ..tags = [];
    _topiclist.add(desc);

    return _topiclist;
  }

   */

//  static List<VideoDesc> loadVideoList() {
//    List<VideoDesc> _videolist = new List<VideoDesc>();
//
//    VideoDesc desc;
//
//    {
//      desc = VideoDesc()
//        ..videoKey = 'nRsxWt3BWzM'
//        ..comment = 'Dart언어 한시간만에 건너뛰기';
//      _videolist.add(desc);
//
//      desc = VideoDesc()
//        ..videoKey = 'CCMuCvcOfnQ'
//        ..comment = 'Dart언어 기본 강좌 세번째 | Flutter Future(Async)';
//      _videolist.add(desc);
//
//      desc = VideoDesc()
//        ..videoKey = 'AKOUDHZsBP0'
//        ..comment = 'Dart언어 기본 강좌 네번째 | Flutter Stream';
//      _videolist.add(desc);
//    }
//
//    return _videolist;
//  }

  static List<LessonDesc> loadLessonList() {
    List<LessonDesc> _lessonlist = new List<LessonDesc>();

    LessonDesc desc;

    desc = LessonDesc()
      ..lessonId = 'flutter_001'
      ..mainTopicId = 'flutter_topic'
      ..title = 'Dart 언어 기본 강좌'
      ..description = '플러터 입문자를 위한 가이드 강좌입니다'
      ..recommanded = 2
      ..imageAssetPath = ''
      //..videoList = ['nRsxWt3BWzM', 'CCMuCvcOfnQ', 'AKOUDHZsBP0']
      ..level = LessonLevel.Beginnger
      ..tags = {'Widget'};

    _lessonlist.add(desc);

    return _lessonlist;
  }
}
