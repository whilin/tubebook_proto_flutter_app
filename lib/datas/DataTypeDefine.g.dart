// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataTypeDefine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBEntity _$DBEntityFromJson(Map<String, dynamic> json) {
  return DBEntity();
}

Map<String, dynamic> _$DBEntityToJson(DBEntity instance) => <String, dynamic>{};

TopicDesc _$TopicDescFromJson(Map<String, dynamic> json) {
  return TopicDesc()
    ..topicId = json['topicId'] as String
    ..section = json['section'] as String
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..imageAssetPath = json['imageAssetPath'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TopicDescToJson(TopicDesc instance) => <String, dynamic>{
      'topicId': instance.topicId,
      'section': instance.section,
      'name': instance.name,
      'description': instance.description,
      'imageAssetPath': instance.imageAssetPath,
      'tags': instance.tags,
    };

ChannelDesc _$ChannelDescFromJson(Map<String, dynamic> json) {
  return ChannelDesc()
    ..channelId = json['channelId'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$ChannelDescToJson(ChannelDesc instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'name': instance.name,
    };

LessonVideo _$LessonVideoFromJson(Map<String, dynamic> json) {
  return LessonVideo()
    ..videoKey = json['videoKey'] as String
    ..title = json['title'] as String;
}

Map<String, dynamic> _$LessonVideoToJson(LessonVideo instance) =>
    <String, dynamic>{
      'videoKey': instance.videoKey,
      'title': instance.title,
    };

LessonDesc _$LessonDescFromJson(Map<String, dynamic> json) {
  return LessonDesc()
    ..lessonId = json['lessonId'] as String
    ..mainTopicId = json['mainTopicId'] as String
    ..youtuberId = json['youtuberId'] as String
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toSet()
    ..level = _$enumDecodeNullable(_$LessonLevelEnumMap, json['level'])
    ..recommanded = json['recommanded'] as int
    ..imageAssetPath = json['imageAssetPath'] as String
    ..videoList = (json['videoList'] as List)?.map((e) => e as String)?.toList()
    ..publish = json['publish'] as int
    ..videoListEx = (json['videoListEx'] as List)
        ?.map((e) =>
            e == null ? null : LessonVideo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$LessonDescToJson(LessonDesc instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'mainTopicId': instance.mainTopicId,
      'youtuberId': instance.youtuberId,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags?.toList(),
      'level': _$LessonLevelEnumMap[instance.level],
      'recommanded': instance.recommanded,
      'imageAssetPath': instance.imageAssetPath,
      'videoList': instance.videoList,
      'publish': instance.publish,
      'videoListEx': instance.videoListEx,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$LessonLevelEnumMap = {
  LessonLevel.Beginnger: 'Beginnger',
  LessonLevel.Intermediate: 'Intermediate',
  LessonLevel.Advanced: 'Advanced',
};

VideoDesc _$VideoDescFromJson(Map<String, dynamic> json) {
  return VideoDesc()
    ..videoKey = json['videoKey'] as String
    ..channelId = json['channelId'] as String
    ..description = json['description'] as String
    ..title = json['title'] as String
    ..hintTopic = json['hintTopic'] as String
    ..hintLesson = json['hintLesson'] as String
    ..markTag = json['markTag'] as int;
}

Map<String, dynamic> _$VideoDescToJson(VideoDesc instance) => <String, dynamic>{
      'videoKey': instance.videoKey,
      'channelId': instance.channelId,
      'description': instance.description,
      'title': instance.title,
      'hintTopic': instance.hintTopic,
      'hintLesson': instance.hintLesson,
      'markTag': instance.markTag,
    };

TopicData _$TopicDataFromJson(Map<String, dynamic> json) {
  return TopicData(
    json['topicId'] as String,
  )..favorited = json['favorited'] as bool;
}

Map<String, dynamic> _$TopicDataToJson(TopicData instance) => <String, dynamic>{
      'topicId': instance.topicId,
      'favorited': instance.favorited,
    };

LessonData _$LessonDataFromJson(Map<String, dynamic> json) {
  return LessonData(
    json['lessonId'] as String,
  )
    ..favorited = json['favorited'] as bool
    ..subscribed = json['subscribed'] as bool
    ..completed = json['completed'] as bool
    ..lastPlayVideoKey = json['lastPlayVideoKey'] as String;
}

Map<String, dynamic> _$LessonDataToJson(LessonData instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'favorited': instance.favorited,
      'subscribed': instance.subscribed,
      'completed': instance.completed,
      'lastPlayVideoKey': instance.lastPlayVideoKey,
    };

VideoData _$VideoDataFromJson(Map<String, dynamic> json) {
  return VideoData(
    json['videoKey'] as String,
  )
    ..completed = json['completed'] as bool
    ..maxTime = (json['maxTime'] as num)?.toDouble()
    ..time = (json['time'] as num)?.toDouble();
}

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'videoKey': instance.videoKey,
      'completed': instance.completed,
      'maxTime': instance.maxTime,
      'time': instance.time,
    };

MyStudyStat _$MyStudyStatFromJson(Map<String, dynamic> json) {
  return MyStudyStat()..userKey = json['userKey'] as String;
}

Map<String, dynamic> _$MyStudyStatToJson(MyStudyStat instance) =>
    <String, dynamic>{
      'userKey': instance.userKey,
    };
