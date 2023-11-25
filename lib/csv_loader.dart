import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class CsvLoader {
  static Future<List<List<dynamic>>> loadCsv(String path) async {
    String csvString = await rootBundle.loadString(path);
    return const CsvToListConverter().convert(csvString);
  }
}