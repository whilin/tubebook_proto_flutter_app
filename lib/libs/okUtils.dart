
import 'package:flutter/material.dart';

double toHDWidth(double height) {
  return height * (16 / 9);
}

double toHDHeight(double width) {
  return width * (9 / 16);
}


double toSDWidth(double height) {
  return height * (4 / 3);
}

double toSDHeight(double width) {
  return width * (3 / 4);
}

AssetImage getImageAsset(String fileaname) {
  String f= "assets/images/" + (fileaname ?? 'topic_youtube.png');
  return AssetImage(f);
}


AssetImage getTopicLogo(String topicId) {
  String f= 'assets/topic_logo/'+ (topicId ?? 'topic_youtube')+'.png';
  return AssetImage(f);
}

String getTopicLogoAsset(String topicId) {
  String f= 'assets/topic_logo/'+ (topicId ?? 'topic_youtube')+'.png';
  return f;
}

String getImageAssetFile(String fileaname) {
 return "assets/images/" + (fileaname ?? 'title_java.png');
}

String getDatasetAsset(String fileaname) {
  return "assets/datasets/" + (fileaname ?? 'title_java.png');
}