import 'dart:io';
import 'package:mydemo_tabnavi2/datas/DataTypeDefine.dart';
import 'package:mydemo_tabnavi2/libs/okExcelReader.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';

void main() {
  var file = "MyYoutube_영상리스트.xlsx";
  /*
  var bytes = File(file).readAsBytesSync();
  var decoder = Excel.decodeBytes(bytes, update: true);

  for (var table in decoder.tables.keys) {
    print(table);
    print(decoder.tables[table].maxCols);
    print(decoder.tables[table].maxRows);
    for (var row in decoder.tables[table].rows) {
      print("$row");
    }
  }

  var table = decoder.tables['Flutter'];
  var row = table.rows[0][0];
*/
/*
  var reader = ExcelDataReader();

  reader.initExcelFile(file, 'Flutter').then((on) {

  }, onError: () {

  });

  try {
    while (reader.nextEntityRow()) {
      String id = reader.readString(0);
      String title = reader.readString(1);
      List<String> videoKeys = reader.readStringList(5);

      print(id + title + videoKeys.toString());
    }
  } catch (e) {
    print("Excel Reader Error :" +
        e.toString() +
        " in Cell(${reader.lastRow.toString()},${reader.lastCol.toString()})");
  }
*/
  ReadLessonList();
}

Future ReadLessonList() async {
  var file = "MyYoutube_영상리스트.xlsx";
  var reader = okExcelReader();

  await reader.loadExcelFile(file, 'Flutter');

  try {
    while (reader.nextEntityRow()) {
      String id = reader.readString(0);
      String title = reader.readString(1);
      List<String> videoKeys = reader.readStringList(5);

      print(id + title + videoKeys.toString());

      LessonDesc desc = LessonDesc();
      desc.lessonId = id;
      desc.title = title;
      desc.videoList = videoKeys;
    }
  } catch (e) {
    print(e);
  }
}
