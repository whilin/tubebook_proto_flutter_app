


import 'dart:math';

import 'package:mydemo_tabnavi2/datas/course_play_model.dart';

import 'YoutubeDataManager.dart';

enum LessonLevel {
  Beginnger,
  Intermediate,
  Advanced,
}

class TopicDesc
{
  String topicId;

  String name;
  String imageAssetPath;
  // List<SubCategoryDesc> subCateList;

  List<String> tags;
}

class YoutuberDesc
{
  String youtuberId;
  String name;
}

class LessonDesc
{
  String lessonId;

  String mainTopicId;
  String youtuberId;

  String title;
  String description;
  Set<String> tags;

  LessonLevel level;
  int recommanded;

  String imageAssetPath;


  List<String> videoList = List<String> ();

  LessonData _data ;

  LessonData get data {
    if(_data ==null) {
      _data = LessonPlayModel.singleton().getLessonData(lessonId);
    }
    return _data;
  }

  List<int> getProgressStatus()
  {
    int completed = 0;

    for(var key in videoList)
      {
        var videoData = LessonPlayModel.singleton().getVideoData(key);
        if ( videoData.completed || videoData.time > 0 )
          completed++;
      }

    return [ videoList.length, completed];
  }
}

class VideoDesc
{
  String videoKey;
  //String videoURL;
  String comment;

  YoutubeData snippet;

  VideoData _data;

  VideoData get data {
    if(_data ==null)
      _data = LessonPlayModel.singleton().getVideoData(videoKey);

    return _data;
  }

  double get totalPlayTime {
    return snippet.durationH * 60.0 * 60.0 + snippet.durationM * 60.0 + snippet.durationS;
  }

  String get playTimeText {
    String text = '';

    if(snippet.durationH > 0)
      text += '${snippet.durationH}시간 ';

    text += '${snippet.durationM}분 ${snippet.durationS}초';
    return text;
  }

  double get progress {
    double t = totalPlayTime;
    double p = data.time;

    return min( p / t, 1);
  }
}

//!

class TopicData
{
  String topicId;
  bool favorited = false;

  TopicData(this.topicId);
}

class LessonData
{
  String lessonId;
  bool favorited;
  String lastPlayVideoKey;

  LessonData(this.lessonId) :
        favorited = false ,
        lastPlayVideoKey = null;
}

enum PlayingState
{
  Unread,
  Paused,
  Playing,
  Completed,
}

class VideoData
{
  String videoKey;

  bool completed = false;
  //bool playing = false;
  double time = 0.0;

  VideoData(this.videoKey) {}
}

