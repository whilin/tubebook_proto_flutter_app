import 'dart:convert';
import 'dart:io';

//import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:excel/excel.dart';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/libs/okExcelReader.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/*
enum LessonLevel {
  Beginnger,
  Intermediate,
  Advanced,
}


class LessonDesc {
  String lessonId;

  String mainTopicId;
  String youtuberId;

  String title;
  String description;
  Set<String> tags;

  LessonLevel level;
  int recommanded;

  String imageAssetPath;

  List<String> videoList = List<String>();

  LessonDesc();

  LessonDesc.fromJson(Map<String, dynamic> json) {
    lessonId = json['lessonId'];

    videoList = List<String>.from(json[videoList]);
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'mainTopicId': mainTopicId,
      'youtuberId': youtuberId,
      'title': title,
      'description': description,
      'tags': tags.toList(),
      'level': level.index,
      'recommanded': recommanded,
      'imageAssetPath': imageAssetPath,
      'videoList': videoList
    };
  }
}

class VideoDesc {
  String videoKey;

  //String videoURL;
  String comment;

  Map<String, dynamic> toJson() {
    return {'videoKey': videoKey, 'comment': comment};
  }
}
*/

//Note. YoutubePlayer Lib 에서 가져왔음
/// Converts fully qualified YouTube Url to video id.
///
/// If videoId is passed as url then no conversion is done.
String convertUrlToId(String url, {bool trimWhitespaces = true}) {
  assert(url?.isNotEmpty ?? false, 'Url cannot be empty');
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

Future ReadLessonList(String xlsxFile, String outputFile) async {
  // var file = "MyYoutube_영상리스트.xlsx";

  List<TopicDesc> topicList = List<TopicDesc>();
  List<LessonDesc> lessonList = List<LessonDesc>();
  List<VideoDesc> videoList = List<VideoDesc>();

  var reader = okExcelReader();

  try {
    await reader.loadExcelFile(xlsxFile);

    reader.selectPage('Topic');
    while (reader.nextEntityRow()) {
      TopicDesc desc = TopicDesc();
      desc.topicId = reader.readString(0);
      desc.name = reader.readString(1);
      desc.section = reader.readString(2);
      desc.imageAssetPath = reader.readString(3);
      desc.description = reader.readString(4);
      desc.tags = reader.readStringList(5);
      topicList.add(desc);
    }

    print('Topic List:'+topicList.map((e)=> e.topicId).toList().toString());

    for (var topic in topicList) {
      if(reader.selectPage(topic.topicId)) {

        int lessonCount = 0;
        int videoCount = 0;

        while (reader.nextEntityRow()) {
          LessonDesc desc = LessonDesc();

          desc.lessonId = reader.readString(0);
          desc.title = reader.readString(1);
          desc.mainTopicId = reader.readString(2);
          desc.tags = reader.readStringList(3).toSet();
          desc.description = reader.readString(4);
          desc.level =
              EnumToString.fromString(LessonLevel.values, reader.readString(5));
          desc.recommanded = reader.readInt(6);
          desc.imageAssetPath = reader.readString(7);
          desc.videoList = reader.readStringList(8);
          desc.videoList =
              desc.videoList.map((e) => convertUrlToId(e)).toList();

          var comments = reader.readStringFixedList(9, desc.videoList.length);

          lessonList.add(desc);
          lessonCount++;

          for (int i = 0; i < desc.videoList.length; i++) {
            VideoDesc v = VideoDesc();

            v.videoKey = desc.videoList[i];
            v.comment = comments[i];
            videoList.add(v);
            videoCount++;
           // print('Video Info ${v.videoKey}, ${v.comment}');
          }
        }

        print('Topic [${topic.topicId}] contains lesson $lessonCount, video $videoCount');

      } else {
        print ("Topic [${topic.topicId}] page not found");
      }
    }
  } catch (e, stack) {
    print(e.toString());
    print(stack);
  }

  String jsonData = jsonEncode(lessonList);
  // print(jsonData);

  File(outputFile + '_lesson.json').writeAsString(jsonData).then((f) {
    print('file save completed');
  });

  String vjsonData = jsonEncode(videoList);
  File(outputFile + '_video.json').writeAsString(vjsonData).then((f) {
    print('file save completed');
  });

  String jsonTopic = jsonEncode(topicList);
  File(outputFile + '_topic.json').writeAsString(jsonTopic).then((f) {
    print('file save completed');
  });
}

Future<void> main(List<String> arguments) async {
  if (arguments.length < 2)
    throw Exception("Too a few arguments, <inputFile> <outputFile>");

  await ReadLessonList(arguments[0], arguments[1]);
}
