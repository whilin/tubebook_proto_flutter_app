

import 'dart:math';

import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';

import 'LessonDataManager.dart';

List<int> getLessonProgress(LessonDesc desc)
{
  int completed = 0;

  for(var key in desc.videoList)
  {
    var videoData = LessonDataManager.singleton().getVideoData(key);
    if ( videoData.completed || videoData.time > 0 )
      completed++;
  }

  return [ desc.videoList.length, completed];
}


double getVideoProgress(VideoDesc desc) {
  var data = LessonDataManager.singleton().getVideoData(desc.videoKey);
  double t = desc.totalPlayTime;
  double p = data.time;

  return min( p / t, 1);
}

bool isPlayingLesson(LessonDesc desc) {
//  List<int> progs =  getLessonProgress(desc);
//  return progs[1] > 0;

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