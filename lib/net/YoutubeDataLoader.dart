import 'dart:convert';

//import 'package:flutter/foundation.dart';
//import 'package:youtube_api/youtube_api.dart';
import '../datas/DataTypeDefine.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:youtube_api/_api.dart';



class YoutubeDataLoader {

  static const String API_KEY = 'AIzaSyApbo42yJQc2GyE02YxY4lZeIToMR75zBA';
  static final YoutubeDataLoader _singleton = new YoutubeDataLoader._internal();

  YoutubeDataLoader._internal();

  factory YoutubeDataLoader.singleton() {
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


