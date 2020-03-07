import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



class okLocalDatabase {
  static const String dbName = 'superpower.db';
  static const String tableName = "section_table";

  static final okLocalDatabase _singleton = new okLocalDatabase._internal();

  okLocalDatabase._internal();

  factory okLocalDatabase.singleton() {
    return _singleton;
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE $tableName (section TEXT PRIMARY KEY, document TEXT)
        ''');
      },
    );
  }

  Future<void> updateSection(String section, dynamic obj) async {
    String jsonString = jsonEncode(obj);

    final db = await database;
    var res =
        await db.query(tableName, where: 'section = ?', whereArgs: [section]);

    Map<String, dynamic> tableObj = new Map();
    tableObj['section'] = section;
    tableObj['document'] = jsonString;

    if (res.length == 0) {
      await db.insert(tableName, tableObj );
    } else {
      await db.update(tableName, tableObj, where: 'section = ?', whereArgs: [section]);
    }
  }


  Future<List<dynamic>> readSection(String section) async {
    final db = await database;
    var res =
        await db.query(tableName, where: 'section = ?', whereArgs: [section]);

    if (res.length == 0) {
      return null;
    } else {
      Map row = res[0];
      String section = row['section'];
      String document = row['document'];

      var jsonMap = jsonDecode(document);
      return jsonMap;
    }
  }
}

