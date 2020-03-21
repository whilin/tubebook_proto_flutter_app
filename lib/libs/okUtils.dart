
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
  String f= "assets/images/" + fileaname;
  return AssetImage(f);
}

String getImageAssetFile(String fileaname) {
 return "assets/images/" + fileaname;
}

String getDatasetAsset(String fileaname) {
  return "assets/datasets/" + fileaname;
}