import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// getGuideline
var guidelines = [];
final guidelinesChanged = ChangeNotifier();

// getTesting
var testings = [];
final testingsChanged = ChangeNotifier();

//getWord
var word = "";
final wordChanged = ChangeNotifier();

//getWord
var news = [];
final newsChanged = ChangeNotifier();

// แนวข้อสอบ
void getGuideline() async {
  final result = await http.get(
    Uri.parse('https://xn--42cm7czac0a7jb0li.com/getGuideline.php'),
  );

  final json = jsonDecode(result.body);
  guidelines.clear();
  guidelines.addAll(json);
  guidelinesChanged.notifyListeners();
}

// ข้อสอบ
void getTesting() async {
  final result = await http.get(
    Uri.parse('https://xn--o3cdd5af5d5a4j.com/getExamsApp.php'),
  );

  final json = jsonDecode(result.body);
  testings.clear();
  for (int i = 0; i < json.length; i++) {
    testings.add(
      {
        'topic': i,
        'question': json[i]['question'],
        'ch1': json[i]['ch1'],
        'ch2': json[i]['ch2'],
        'ch3': json[i]['ch3'],
        'ch4': json[i]['ch4'],
        'ref': json[i]['ref'],
        'img': json[i]['img'],
        'answer': json[i]['answer'],
        'answer_user': '0',
      },
    );
  }
  testingsChanged.notifyListeners();
}

// word
void getWord() async {
  final result = await http.get(
    Uri.parse('https://xn--42cm7czac0a7jb0li.com/getWordApp.php'),
  );

  final json = jsonDecode(result.body);
  word = json['word'];
  wordChanged.notifyListeners();
}

// news
void getNews() async {
  final result = await http.get(
    Uri.parse('https://xn--42cm7czac0a7jb0li.com/getNews.php'),
  );

  final json = jsonDecode(result.body);
  news.add(json);
  newsChanged.notifyListeners();
}