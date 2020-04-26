import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:mydemo_tabnavi2/net/YoutubeApi.dart';
part 'DataTypeDefine.g.dart';

enum LessonLevel {
  Beginnger,
  Intermediate,
  Advanced,
}


enum TopicType {
  Category,
  Curation
}


enum ChannelType {
  Creator,
  Curator
}

@JsonSerializable()
class DBEntity {

  @JsonKey(name : '_id')
  String id;

  DBEntity();

  DBEntity.fromJson(Map<String, dynamic> map) : id = map['_id'];

  String get objectId {
    return id;
  }

}



@JsonSerializable()
class TopicDesc  extends DBEntity
{
  String topicId;
  String name;

  String section;

  @JsonKey(defaultValue: TopicType.Category)
  TopicType topicType;
  String channelId; //Creator or Curator Id


  TopicDesc();

  factory TopicDesc.fromJson(Map<String, dynamic> json) => _$TopicDescFromJson(json);
  Map<String, dynamic> toJson() => _$TopicDescToJson(this);
}


@JsonSerializable()
class ChannelDesc  extends DBEntity
{
  String channelId;
  String name;
  @JsonKey(defaultValue: ChannelType.Creator)
  ChannelType channelType;

  String yt_thumnail_default_url;
  String yt_thumnail_medium_url;
  String yt_thumnail_high_url;
  String yt_publishedAt;

  ChannelDesc();

  factory ChannelDesc.fromJson(Map<String, dynamic> json) => _$ChannelDescFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelDescToJson(this);


 // @JsonKey(ignore: true)
 // YoutubeChannelData snippet;
}


@JsonSerializable()
class LessonVideo {
  String videoKey;
  String title;

  String yt_title;
  String yt_duration;
  String yt_thumnail_default_url;
  String yt_thumnail_medium_url;
  String yt_thumnail_high_url;
  String yt_publishedAt;

  int durationH;
  int durationM;
  int durationS;

  LessonVideo();

  factory LessonVideo.fromJson(Map<String, dynamic> json) => _$LessonVideoFromJson(json);
  Map<String, dynamic> toJson() =>_$LessonVideoToJson(this);

 // @JsonKey(ignore: true)
 // YoutubeVideoData snippet;


  double get totalPlayTime {

    if(yt_duration==null)
        return 1;

    return durationH * 60.0 * 60.0 + durationM * 60.0 + durationS;
  }

  String get playTimeText {
    String text = '';
    if(yt_duration ==null)
        return text;

    if(durationH > 0)
      text += '${durationH}시간 ';

    text += '${durationM}분 ${durationS}초';
    return text;
  }

}

@JsonSerializable()
class LessonDesc  extends DBEntity
{
  String lessonId;

  String mainTopicId;
  String subTopicId;

  String youtuberId;

  String title;
  String description;
  String detailDescription;

  Set<String> tags;

  LessonLevel level;
  int recommanded;

  String imageAssetPath;

  int publish;

  //List<String> videoList = List<String>();

  List<LessonVideo> videoListEx = new List<LessonVideo>();

  LessonDesc();

  factory LessonDesc.fromJson(Map<String, dynamic> json) => _$LessonDescFromJson(json);
  Map<String, dynamic> toJson() => _$LessonDescToJson(this);
}


/*
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
*/

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
  bool favorited =false;
  bool subscribed=false;
  bool completed=false;
  String lastPlayVideoKey=null;

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


  @JsonKey(defaultValue: false)
  bool completed = false;

  @JsonKey(defaultValue: 0.0)
  double maxTime  = 0.0;

  @JsonKey(defaultValue: 0.0)
  double time = 0.0;

  VideoData(this.videoKey) {}

  void setPlayTime(double time) {
      this.time = time;
      maxTime = max(this.time, maxTime);
  }


  factory VideoData.fromJson(Map<String, dynamic> json) => _$VideoDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}



@JsonSerializable()
class MyStudyStat
{
  String userKey;

}