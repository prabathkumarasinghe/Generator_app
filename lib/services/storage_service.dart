import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/generator.dart';
import '../models/record.dart';

class StorageService {
  static const String generatorKey = "generators";
  static const String entryDraftKey = "entryDraft";

  static Future<void> saveGenerators(List<GeneratorModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = list.map((e) => jsonEncode(e.toJson())).toList();
    final saved = await prefs.setStringList(generatorKey, data);
    if (!saved) {
      throw Exception("Generator details could not be saved");
    }
  }

  static Future<List<GeneratorModel>> loadGenerators() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final data = prefs.getStringList(generatorKey) ?? [];
      return data.map((e) => GeneratorModel.fromJson(jsonDecode(e))).toList();
    } catch (e) {
      // Return empty list if error
      return [];
    }
  }

  static const String recordKey = "records";

  static Future<void> saveRecords(List<Record> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = list.map((e) => jsonEncode(e.toJson())).toList();
    final saved = await prefs.setStringList(recordKey, data);
    if (!saved) {
      throw Exception("Record details could not be saved");
    }
  }

  static Future<List<Record>> loadRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final data = prefs.getStringList(recordKey) ?? [];
      return data.map((e) => Record.fromJson(jsonDecode(e))).toList();
    } catch (e) {
      // Return empty list if error
      return [];
    }
  }

  static Future<void> saveEntryDraft(Map<String, dynamic> draft) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(entryDraftKey, jsonEncode(draft));
    if (!saved) {
      throw Exception("Entry draft could not be saved");
    }
  }

  static Future<Map<String, dynamic>?> loadEntryDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final data = prefs.getString(entryDraftKey);
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearEntryDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(entryDraftKey);
  }
}
