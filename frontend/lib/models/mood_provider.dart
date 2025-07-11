import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodProvider extends ChangeNotifier {
  String _mood = '';
  List<String> _journalEntries = [];

  String get mood => _mood;
  List<String> get journalEntries => _journalEntries;

  MoodProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _mood = prefs.getString('mood') ?? '';
    _journalEntries = prefs.getStringList('journal') ?? [];
    notifyListeners();
  }

  void updateMood(String newMood) async {
    _mood = newMood;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mood', _mood);
    notifyListeners();
  }

  void addJournalEntry(String entry) async {
    _journalEntries.add(entry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('journal', _journalEntries);
    notifyListeners();
  }

  void setJournalEntries(List<String> entries) {
  _journalEntries = entries;
  notifyListeners();
}

}
