import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';


class okExcelReader {
  static const START_ROW_INDEX = 1;
  static const START_COL_INDEX = 0;

  String _filename;
  String _sheetname;
  List<String> _sheetNames;

  Excel decoder;
  DataTable table;

  int _currentRow = START_ROW_INDEX - 1;

  int _lastRow = -1;
  int _lastCol = -1;

  okExcelReader() {}

  Future<bool> loadExcelFile(String filename) async {

    try {
      _filename = filename;

      _lastRow = -1;
      _lastCol = -1;
      _currentRow = 0;

      var bytes = await File(filename).readAsBytes();
      decoder = Excel.decodeBytes(bytes, update: false);
      _sheetNames = List.of(decoder.tables.keys);

      selectPage(decoder.tables.keys.first);

      return true;
    } catch(e) {
      throw Exception('Excel $filename open error');
    }
  }

  bool selectPage(String sheetName) {
    if(!_sheetNames.contains(sheetName))
      return false;

    try {

      table = decoder.tables[sheetName];

      _lastRow = -1;
      _lastCol = -1;
      _currentRow = 0;

      return true;
    } catch(e) {
      throw Exception('Excel $sheetName open error');
    }
  }

  bool nextEntityRow() {

    try {
      for (int i = (_currentRow + 1); i < table.maxRows; i++) {
        var data = table.rows[i][START_COL_INDEX];
        if (data != null) {
          _currentRow = i;
          return true;
        }
      }

      return false;
    } catch(e) {
      throw Exception('Excel read error in nextEntityRow');
    }
  }

  dynamic _read(int col) {

    try {
      _lastRow = _currentRow;
      _lastCol = col;
      return table.rows[_currentRow][col];
    } catch (e) {
      throw Exception('Excel read error in ($_lastRow : $_lastCol)');
    }
  }

  dynamic _readRow(int row, int col) {
    try {
      _lastRow = row;
      _lastCol = col;
      return table.rows[row][col];
    } catch (e) {
      throw Exception('Excel read error in ($_lastRow : $_lastCol)');
    }
  }

  int readInt(int col) {
    var val = _read(col) ?? 0;
    return val;
  }

  String readString(int col) {
    var val = _read(col) ?? '';
    return val;
  }

  List<String> readStringList(int col) {
    List<String> vals = [];
    for (int r = _currentRow; r < table.maxRows; r++) {
      var val = _readRow(r, col);
      if (val == null) break;
      vals.add(val);
    }

    return vals;
  }


  List<String> readStringFixedList(int col, int fixedSize) {
    List<String> vals = [];
    for (int r = _currentRow; r < (fixedSize+_currentRow); r++) {
      var val = _readRow(r, col) ?? '';
      vals.add(val);
    }

    return vals;
  }

}
