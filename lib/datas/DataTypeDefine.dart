import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
part 'DataTypeDefine.g.dart';

enum LessonLevel {
  Beginnger,
  Intermediate,
  Advanced,
}


@JsonSerializable()
class DBEntity {
  String _id;

  DBEntity();

  DBEntity.fromJson(Map<String, dynamic> map) : _id = map['_id'];

  String get objectId {
    return _id;
  }
}


@JsonSerializable()
class TopicDesc  extends DBEntity
{
  String topicId;
  String section;

  String name;
  String description;

  String imageAssetPath;

  List<String> tags;

  TopicDesc();

  factory TopicDesc.fromJson(Map<String, dynamic> json) => _$TopicDescFromJson(json);
  Map<String, dynamic> toJson() => _$TopicDescToJson(this);
}


@JsonSerializable()
class ChannelDesc  extends DBEntity
{
  String channelId;
  String name;

  ChannelDesc();

  factory ChannelDesc.fromJson(Map<String, dynamic> json) => _$ChannelDescFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelDescToJson(this);
}


@JsonSerializable()
class LessonVideo {
  String videoKey;
  String title;

  LessonVideo();

  factory LessonVideo.fromJson(Map<String, dynamic> json) => _$LessonVideoFromJson(json);
  Map<String, dynamic> toJson() =>_$LessonVideoToJson(this);

  @JsonKey(ignore: true)
  YoutubeData snippet;


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
}

@JsonSerializable()
class LessonDesc  extends DBEntity
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


  int publish;
  List<LessonVideo> videoListEx = new List<LessonVideo>();

  LessonDesc();

  factory LessonDesc.fromJson(Map<String, dynamic> json) => _$LessonDescFromJson(json);
  Map<String, dynamic> toJson() => _$LessonDescToJson(this);
}


@JsonSerializable()
class VideoDesc  extends DBEntity
{
  //String videoKey;
  //String comment;

  String videoKey;
  String channelId;
  String description;
  String title;

  String hintTopic;
  String hintLesson;
  int markTag;


  VideoDesc();

  factory VideoDesc.fromJson(Map<String, dynamic> json) => _$VideoDescFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDescToJson(this);

  @JsonKey(ignore: true)
  YoutubeData snippet;


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
}


//!
@JsonSerializable()
class TopicData
{
  String topicId;
  bool favorited = false;

  TopicData(this.topicId);

  factory TopicData.fromJson(Map<String, dynamic> json) => _$TopicDataFromJson(json);
  Map<String, dynamic> toJson() => _$TopicDataToJson(this);
}

@JsonSerializable()
class LessonData
{
  String lessonId;
  bool favorited;
  bool subscribed;
  bool completed;

  String lastPlayVideoKey;

  LessonData(this.lessonId) :
        favorited = false ,
        subscribed = false,
        completed = false,
        lastPlayVideoKey = null;


  factory LessonData.fromJson(Map<String, dynamic> json) => _$LessonDataFromJson(json);
  Map<String, dynamic> toJson() => _$LessonDataToJson(this);

}

enum PlayingState
{
  Unread,
  Paused,
  Playing,
  Completed,
}

@JsonSerializable()
class VideoData
{
  String videoKey;

  bool completed = false;
  double maxTime  = 0.0;
  double time = 0.0;

  VideoData(this.videoKey) {}

  void setPlayTime(double time) {
      this.time = time;
      maxTime = max(this.time, maxTime);
  }


  factory VideoData.fromJson(Map<String, dynamic> json) => _$VideoDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}


class YoutubeData {

  dynamic thumbnail;

  String kind,
      id,
      publishedAt,
      channelId,
      channelurl,
      title,
      description,
      channelTitle,
      url;

  String duration,
      dimension,
      definition;

  bool caption;

  int durationH;
  int durationM;
  int durationS;

  YoutubeData(this.id , dynamic itemData) {

    //Snippet Info

    thumbnail = {
      'default': itemData['snippet']['thumbnails']['default'],
      'medium': itemData['snippet']['thumbnails']['medium'],
      'high': itemData['snippet']['thumbnails']['high']
    };

    publishedAt = itemData['snippet']['publishedAt'];
    channelId = itemData['snippet']['channelId'];
    channelurl = "https://www.youtube.com/channel/$channelId";
    title = itemData['snippet']['title'];
    description = itemData['snippet']['description'];
    channelTitle = itemData['snippet']['channelTitle'];

    kind = "video";
    url = _getURL(kind, id);


    //contentDetails
    duration = itemData['contentDetails']['duration'];
    dimension = itemData['contentDetails']['dimension'];
    definition = itemData['contentDetails']['definition'];
    caption =  itemData['contentDetails']['caption'] == 'true';

    parseDurationTime(duration);
  }

  void parseDurationTime(String isoTime)
  {

//      //"duration": "PT15M51S",
//      List<String> _list = isoTime.split(RegExp('[0-9]'));
//      String isoTime = "PT15M51S";
//      List<String> _list = isoTime.split(RegExp('[A-Z]+'));
//      // isoTime.allMatches(string);

    final iReg = RegExp(r'(\d+)');
    var list = iReg.allMatches(isoTime).map((m) => m.group(0)).toList();

    durationH = 0;
    durationM = 0;
    durationS = 0;

    if(list.length ==3) {
      durationH = int.parse(list[0]);
      durationM = int.parse(list[1]);
      durationS = int.parse(list[2]);
    } else if( list.length ==2) {
      durationH = 0;
      durationM = int.parse(list[0]);
      durationS = int.parse(list[1]);
    } else if( list.length == 1) {
      durationH = 0;
      durationM = 0;
      durationS = int.parse(list[0]);
    }

  }

  String getThumnail({int level=0})  {

    switch(level)
    {
      case 1 : return thumbnail['medium'];
      case 2 : return thumbnail['high'];
      default: return thumbnail['default'];
    }

  }

  String _getURL(String kind, String id) {
    String baseURL = "https://www.youtube.com/";
    switch (kind) {
      case 'channel':
        return "$baseURL watch?v=$id";
        break;
      case 'video':
        return "$baseURL watch?v=$id";
        break;
      case 'playlist':
        return "$baseURL watch?v=$id";
        break;
    }
    return baseURL;
  }

}


@JsonSerializable()
class MyStudyStat
{
  String userKey;

}