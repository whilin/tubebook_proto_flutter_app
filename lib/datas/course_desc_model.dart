import 'package:flutter/foundation.dart';
import 'package:mydemo_tabnavi2/datas/local_data_loader.dart';

import 'YoutubeDataManager.dart';
import 'course_data_define.dart';



class LessonDescModel with ChangeNotifier {

  static final LessonDescModel _singleton = new LessonDescModel._internal();

  LessonDescModel._internal();

  factory LessonDescModel.singleton() {
    return _singleton;
  }

  final List<TopicDesc> _topiclist = List<TopicDesc>();
  final List<LessonDesc> _lessonList = List<LessonDesc>();
  final List<VideoDesc> _videoList = List<VideoDesc>();

  VideoDesc getVideoDesc(String videoKey)
  {
    try {

      VideoDesc d = _videoList.firstWhere((e) => e.videoKey == videoKey);
      return d;

    }  catch(e) {
      return null;
    }
  }

  List<TopicDesc> getTopicList()
  {
    return _topiclist;
  }

  List<LessonDesc> queryLessionListByTopic(String topicId)
  {
    var iter = _lessonList.where((e) => e.mainTopicId == topicId);
    return iter.toList(growable: false);
  }

  List<VideoDesc> queryVideoList(List<String> videos)
  {
    List<VideoDesc> l = new List<VideoDesc>();

    for(var v in videos)
      {
        var e =   _videoList.firstWhere( (q) {
                                  return q.videoKey == v ;
                                  },
                              orElse : () {
                                return null;
                              });
        if ( e != null)
            l.add(e);
      }

    return l;
  }

  Future initializeMetaData() async
  {
    _topiclist.addAll(LocalDataLoader.loadTopicList());

    _lessonList.addAll(LocalDataLoader.loadLessonList());

    _videoList.addAll(LocalDataLoader.loadVideoList());

    await YoutubeDataManager.singleton().loadVideoDetailInfo(_videoList);

    notifyListeners();
  }


}

