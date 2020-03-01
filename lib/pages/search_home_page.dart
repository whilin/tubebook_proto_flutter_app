import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:mydemo_tabnavi2/datas/course_desc_model.dart';
import 'package:provider/provider.dart';

class SearchHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoTabView(builder: (context) {
      final model = Provider.of<LessonDescModel>(context);

      return DecoratedBox(
          decoration: BoxDecoration(color: Color(0xff3C3C3C)),
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBar())));
    });
  }
}
