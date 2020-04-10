

import 'dart:math';

import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import '../managers/LessonDataManager.dart';


List<int> getLessonProgress(LessonDesc desc)
{
  int completed = 0;

  for(var key in desc.videoListEx)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key.videoKey);
    if ( videoData.completed)
      completed++;
  }

  return [ desc.videoListEx.length, completed];
}


bool getLessonCompleted(LessonDesc desc)
{
  int completed = 0;

  for(var key in desc.videoListEx)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key.videoKey);
    if ( videoData.completed)
      completed++;
  }

  return completed == desc.videoListEx.length;
}


bool getLessonCompletedBy(LessonData data)
{
  LessonDesc desc = LessonDescManager.singleton().getLessonDesc (data.lessonId);
  int completed = 0;

  for(var key in desc.videoListEx)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key.videoKey);
    if ( videoData.completed)
      completed++;
  }

  return completed == desc.videoListEx.length;
}

double getVideoProgress(LessonVideo desc) {
  var data = LessonDataManager.singleton().getVideoData(desc.videoKey);
  double t = desc.totalPlayTime;
  double p = data.time;

  return min( p / t, 1);
}


double getVideoProgressMax(LessonVideo desc) {
  var data = LessonDataManager.singleton().getVideoData(desc.videoKey);
  double t = desc.totalPlayTime;
  double p = data.maxTime ?? 0;

  return min( p / t, 1);
}


bool isPlayingLesson(LessonDesc desc) {

  var data = LessonDataManager.singleton().getLessonData(desc.lessonId);
  return data.subscribed !=null && data.subscribed ;
}

String getLevelName(LessonLevel level) {
  switch(level) {
    case LessonLevel.Advanced : return '고급코스';
    case LessonLevel.Intermediate: return '중급코스';
    case LessonLevel.Beginnger: return '초급코스';
    default : return '-';
  }
}