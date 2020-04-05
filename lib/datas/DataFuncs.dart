

import 'dart:math';

import 'package:mydemo_tabnavi2/managers/LessonDescManager.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import '../managers/LessonDataManager.dart';


List<int> getLessonProgress(LessonDesc desc)
{
  int completed = 0;

  for(var key in desc.videoList)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key);
    if ( videoData.completed)
      completed++;
  }

  return [ desc.videoList.length, completed];
}


bool getLessonCompleted(LessonDesc desc)
{
  int completed = 0;

  for(var key in desc.videoList)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key);
    if ( videoData.completed)
      completed++;
  }

  return completed == desc.videoList.length;
}


bool getLessonCompletedBy(LessonData data)
{
  LessonDesc desc = LessonDescManager.singleton().getLessonDesc (data.lessonId);
  int completed = 0;

  for(var key in desc.videoList)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key);
    if ( videoData.completed)
      completed++;
  }

  return completed == desc.videoList.length;
}

double getVideoProgress(VideoDesc desc) {
  var data = LessonDataManager.singleton().getVideoData(desc.videoKey);
  double t = desc.totalPlayTime;
  double p = data.time;

  return min( p / t, 1);
}


double getVideoProgressMax(VideoDesc desc) {
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