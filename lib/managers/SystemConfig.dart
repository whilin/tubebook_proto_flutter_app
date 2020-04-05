import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemConfig {
  static final SystemConfig _singleton = new SystemConfig._internal();

  SystemConfig._internal();

  factory SystemConfig.singleton() {
    return _singleton;
  }

  void changePlaySpeed() async {

    var pref = await SharedPreferences.getInstance();
    var value =  pref.get('PlaySpeed');
  }

}


class SpeedEntity {

  static const list = [
    SpeedEntity(0,"배속 x 0.5", PlaybackRate.RATE_0_5),
    SpeedEntity(1,"일반 속도", PlaybackRate.RATE_1),
    SpeedEntity(2,"배속 x 1.5", PlaybackRate.RATE_1_5),
    SpeedEntity(3,"배속 x 2.0", PlaybackRate.RATE_2),
  ];

  final int id;
  final String name;
  final PlaybackRate rate;

  const SpeedEntity(this.id, this.name, this.rate);

  static List<SpeedEntity> getlist() {
    return list;
  }

  static SpeedEntity defaultSpeed() {
    return list[1];
  }

  static SpeedEntity nextSpeed(SpeedEntity cur) {
    var curIdx = list.indexWhere((element) => element.rate == cur.rate);
    curIdx ++;
    if(curIdx >= list.length)
      curIdx = 0;

    return list[curIdx];
  }
}

