import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_model.dart';
import '../models/book_model.dart';
import '../models/language_model.dart';
import '../models/verse_model.dart';

class BibleApiService {
  final String _baseUrl = 'https://bible4u.net/api/v1';

  Future<List<Language>> getLanguages() async {
    final response = await http.get(Uri.parse('$_baseUrl/bibles'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bibleList = data['data'];
      final languages = bibleList
          .map((json) => Language(
                code: json['langId'],
                name: json['language'],
              ))
          .toSet()
          .toList();
      return languages;
    } else {
      throw Exception('Failed to load languages');
    }
  }

  Future<List<Bible>> getBibles(String langCode) async {
    final response = await http.get(Uri.parse('$_baseUrl/bibles'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bibleList = data['data'];
      return bibleList
          .where((json) => json['langId'] == langCode)
          .map((json) => Bible.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load bibles');
    }
  }

  Future<List<Book>> getBooks(String bibleRef) async {
    final response = await http.get(Uri.parse('$_baseUrl/bibles/$bibleRef'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bookList = data['data']['books'];
      return bookList.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Verse>> getVerses(
      String bibleRef, String bookRef, int chapter) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/passage/$bibleRef/$bookRef?start-chapter=$chapter&start-verse=1&end-verse=200'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> verseList = data['data']['verses'];
      return verseList.map((json) => Verse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load verses');
    }
  }
}
