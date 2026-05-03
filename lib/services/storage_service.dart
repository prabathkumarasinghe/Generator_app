import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/generator.dart';

class StorageService {
  static const String key = "generators";

  static Future<void> saveGenerators(List<Generator> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = list.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, data);
  }

  static Future<List<Generator>> loadGenerators() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    return data.map((e) => Generator.fromJson(jsonDecode(e))).toList();
  }
}