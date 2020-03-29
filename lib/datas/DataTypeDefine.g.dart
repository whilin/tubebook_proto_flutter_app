// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataTypeDefine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicDesc _$TopicDescFromJson(Map<String, dynamic> json) {
  return TopicDesc()
    ..topicId = json['topicId'] as String
    ..section = json['section'] as String
    ..name = json['name'] as String
    ..imageAssetPath = json['imageAssetPath'] as String
    ..description = json['description'] as String
    ..tags = (json['tags'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TopicDescToJson(TopicDesc instance) => <String, dynamic>{
      'topicId': instance.topicId,
      'section': instance.section,
      'name': instance.name,
      'imageAssetPath': instance.imageAssetPath,
      'description': instance.description,
      'tags': instance.tags,
    };

YoutuberDesc _$YoutuberDescFromJson(Map<String, dynamic> json) {
  return YoutuberDesc()
    ..youtuberId = json['youtuberId'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$YoutuberDescToJson(YoutuberDesc instance) =>
    <String, dynamic>{
      'youtuberId': instance.youtuberId,
      'name': instance.name,
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
    ..videoList =
        (json['videoList'] as List)?.map((e) => e as String)?.toList();
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
    ..comment = json['comment'] as String;
}

Map<String, dynamic> _$VideoDescToJson(VideoDesc instance) => <String, dynamic>{
      'videoKey': instance.videoKey,
      'comment': instance.comment,
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
    ..lastPlayVideoKey = json['lastPlayVideoKey'] as String;
}

Map<String, dynamic> _$LessonDataToJson(LessonData instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'favorited': instance.favorited,
      'subscribed': instance.subscribed,
      'lastPlayVideoKey': instance.lastPlayVideoKey,
    };

VideoData _$VideoDataFromJson(Map<String, dynamic> json) {
  return VideoData(
    json['videoKey'] as String,
  )
    ..completed = json['completed'] as bool
    ..time = (json['time'] as num)?.toDouble();
}

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'videoKey': instance.videoKey,
      'completed': instance.completed,
      'time': instance.time,
    };

MyStudyStat _$MyStudyStatFromJson(Map<String, dynamic> json) {
  return MyStudyStat()..userKey = json['userKey'] as String;
}

Map<String, dynamic> _$MyStudyStatToJson(MyStudyStat instance) =>
    <String, dynamic>{
      'userKey': instance.userKey,
    };
