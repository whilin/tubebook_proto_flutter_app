// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataTypeDefine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBEntity _$DBEntityFromJson(Map<String, dynamic> json) {
  return DBEntity()..id = json['_id'] as String;
}

Map<String, dynamic> _$DBEntityToJson(DBEntity instance) => <String, dynamic>{
      '_id': instance.id,
    };

TopicDesc _$TopicDescFromJson(Map<String, dynamic> json) {
  return TopicDesc()
    ..id = json['_id'] as String
    ..topicId = json['topicId'] as String
    ..name = json['name'] as String
    ..section = json['section'] as String
    ..topicType = _$enumDecodeNullable(_$TopicTypeEnumMap, json['topicType']) ??
        TopicType.Category
    ..channelId = json['channelId'] as String;
}

Map<String, dynamic> _$TopicDescToJson(TopicDesc instance) => <String, dynamic>{
      '_id': instance.id,
      'topicId': instance.topicId,
      'name': instance.name,
      'section': instance.section,
      'topicType': _$TopicTypeEnumMap[instance.topicType],
      'channelId': instance.channelId,
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

const _$TopicTypeEnumMap = {
  TopicType.Category: 'Category',
  TopicType.Curation: 'Curation',
};

ChannelDesc _$ChannelDescFromJson(Map<String, dynamic> json) {
  return ChannelDesc()
    ..id = json['_id'] as String
    ..channelId = json['channelId'] as String
    ..name = json['name'] as String
    ..channelType =
        _$enumDecodeNullable(_$ChannelTypeEnumMap, json['channelType']) ??
            ChannelType.Creator;
}

Map<String, dynamic> _$ChannelDescToJson(ChannelDesc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'channelId': instance.channelId,
      'name': instance.name,
      'channelType': _$ChannelTypeEnumMap[instance.channelType],
    };

const _$ChannelTypeEnumMap = {
  ChannelType.Creator: 'Creator',
  ChannelType.Curator: 'Curator',
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
    ..id = json['_id'] as String
    ..lessonId = json['lessonId'] as String
    ..mainTopicId = json['mainTopicId'] as String
    ..subTopicId = json['subTopicId'] as String
    ..youtuberId = json['youtuberId'] as String
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..detailDescription = json['detailDescription'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toSet()
    ..level = _$enumDecodeNullable(_$LessonLevelEnumMap, json['level'])
    ..recommanded = json['recommanded'] as int
    ..imageAssetPath = json['imageAssetPath'] as String
    ..publish = json['publish'] as int
    ..videoListEx = (json['videoListEx'] as List)
        ?.map((e) =>
            e == null ? null : LessonVideo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$LessonDescToJson(LessonDesc instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'lessonId': instance.lessonId,
      'mainTopicId': instance.mainTopicId,
      'subTopicId': instance.subTopicId,
      'youtuberId': instance.youtuberId,
      'title': instance.title,
      'description': instance.description,
      'detailDescription': instance.detailDescription,
      'tags': instance.tags?.toList(),
      'level': _$LessonLevelEnumMap[instance.level],
      'recommanded': instance.recommanded,
      'imageAssetPath': instance.imageAssetPath,
      'publish': instance.publish,
      'videoListEx': instance.videoListEx,
    };

const _$LessonLevelEnumMap = {
  LessonLevel.Beginnger: 'Beginnger',
  LessonLevel.Intermediate: 'Intermediate',
  LessonLevel.Advanced: 'Advanced',
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
    ..completed = json['completed'] as bool ?? false
    ..maxTime = (json['maxTime'] as num)?.toDouble() ?? 0.0
    ..time = (json['time'] as num)?.toDouble() ?? 0.0;
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
