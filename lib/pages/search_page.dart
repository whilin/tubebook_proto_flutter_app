import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydemo_tabnavi2/datas/LessonDescManager.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoTabView(builder: (context) {
      final model = Provider.of<LessonDescManager>(context);

      return DecoratedBox(
          decoration: BoxDecoration(color: Color(0xff3C3C3C)),
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBar(
                    searchBarStyle: SearchBarStyle(
                      backgroundColor: Colors.black12,
                      padding: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ))));
    });
  }
}
