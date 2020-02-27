import 'package:flutter/foundation.dart';

import 'course_data_define.dart';


class LessonPlayModel with ChangeNotifier {

  static final LessonPlayModel _singleton = new LessonPlayModel._internal();

  LessonPlayModel._internal();

  factory LessonPlayModel.singleton() {
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

}