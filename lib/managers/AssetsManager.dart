
import 'package:flutter/material.dart';

class AssetsManager {

  static AssetImage getTopicLogo(String topicId) {
    String f= 'assets/topic_logo/'+ (topicId ?? 'topic_youtube')+'.png';
    return AssetImage(f);
  }


}