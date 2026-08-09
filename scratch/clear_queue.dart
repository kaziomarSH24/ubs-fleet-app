import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  Hive.init('./.dart_tool/hive'); // Wait, the path for Flutter hive is different
}
