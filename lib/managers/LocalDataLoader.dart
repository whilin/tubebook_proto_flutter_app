import 'dart:convert';
import 'dart:io';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocalDataLoader {

  List<TopicDesc> topicList = List<TopicDesc>();
  List<LessonDesc> lessonList = List<LessonDesc>();
  List<VideoDesc> videoList = List<VideoDesc>();

  Future<void> loadDataSets() async {

    var topic = await _loadFile('v1_topic.json');
    _loadTopicList(topic);

    var lessonJson = await _loadFile('v1_lesson.json');
    _loadLessonList(lessonJson);

    var videoJson = await _loadFile('v1_video.json');
    _loadVideoList(videoJson);
  }

  Future<String> _loadFile(String filename) async {
    return await rootBundle.loadString('assets/datasets/${filename}');
  }

  void _loadTopicList(String jsonString) {

    List<dynamic>  jsonlistObj =  jsonDecode(jsonString);
    for(dynamic jsonObj in jsonlistObj)  {
      TopicDesc desc = TopicDesc.fromJson(jsonObj);
      topicList.add(desc);
    }
  }

  void _loadLessonList(String jsonString) {

    List<dynamic>  jsonlistObj =  jsonDecode(jsonString);
    for(dynamic jsonObj in jsonlistObj)  {
      LessonDesc desc = LessonDesc.fromJson(jsonObj);
      lessonList.add(desc);
    }
  }

  void _loadVideoList(String jsonString) {

    List<dynamic>  jsonlistObj =  jsonDecode(jsonString);
    for(dynamic jsonObj in jsonlistObj)  {
      VideoDesc desc = VideoDesc.fromJson(jsonObj);
      videoList.add(desc);
    }
  }
}