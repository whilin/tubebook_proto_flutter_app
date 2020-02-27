import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:youtube_api/youtube_api.dart';
import 'course_data_define.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/_api.dart';


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


class YoutubeDataManager {

  static const String API_KEY = 'AIzaSyApbo42yJQc2GyE02YxY4lZeIToMR75zBA';
  static final YoutubeDataManager _singleton = new YoutubeDataManager._internal();

  YoutubeDataManager._internal();

  factory YoutubeDataManager.singleton() {
    return _singleton;
  }

  Future loadVideoDetailInfo(List<VideoDesc> videos) async
  {
    for(var v in videos) {

      YoutubeData info = await _getVieoInfo(v.videoKey);
      v.snippet = info;
    }
  }

  Future<YoutubeData> _getVieoInfo(String videoKey) async
  {
    //API 프로토콜 설명
    //https://developers.google.com/youtube/v3/getting-started

    //  String url = 'https://www.googleapis.com/youtube/v3/videos?id=' + videoKey + '&fields=items(snippet(title))&part=snippet&key=' + key;
    //  String url = 'https://www.googleapis.com/youtube/v3/videos?id=' + videoKey + '&part=snippet&key=' + key;

    String url = 'https://www.googleapis.com/youtube/v3/videos?'+
                        'id=${videoKey}'+
                        '&part=snippet,contentDetails'+
                        '&fields=items(snippet,contentDetails)'+
                        '&key=${API_KEY}';

    var res = await http.get(url, headers: {"Accept": "application/json"});
    var jsonData = json.decode(res.body);

    if (jsonData['error'] != null){
      print(jsonData['error']);
      return null;
    }

    if(jsonData['items'] ==null) {
      return null;
    }

    dynamic items = jsonData['items'];

    YoutubeData info = YoutubeData(videoKey, items[0]);

    return info;
  }
}


