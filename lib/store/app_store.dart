import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:google_sign_in/google_sign_in.dart';

// --- Configuration ---
const String baseUrl = 'http://localhost/mr_robot_backend';
// const String baseUrl = 'https://xn--o3cdd5af5d5a4j.com'; 
const Map<String, String> apiHeaders = {
  'X-Api-Key': 'chaichon',
  'Content-Type': 'application/json',
};

// --- State Variables (General) ---
var predictNumber = "";
final predictNumberChanged = ChangeNotifier();
var predictResult = "";
final predictResultChanged = ChangeNotifier();

var testings = [];
final testingsChanged = ChangeNotifier();

var word = "";
final wordChanged = ChangeNotifier();

var news = [];
final newsChanged = ChangeNotifier();

// --- User & Auth State ---
Map<String, dynamic>? currentUser;
final userChanged = ChangeNotifier();

// --- History & Leaderboard State ---
List historyList = [];
final historyChanged = ValueNotifier<int>(0);

List leaderboardList = [];
final leaderboardChanged = ValueNotifier<int>(0);

// --- Google Sign In Configuration ---
const String webClientId = '694529936527-pp9085pkfvaqjl1l9foaiagb624g6vgr.apps.googleusercontent.com';
const String androidClientId = '694529936527-iajgb2i7n47io5f5kb5mfa69hu2fe9ns.apps.googleusercontent.com';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: kIsWeb ? webClientId : androidClientId,
  scopes: <String>['email', 'profile', 'openid'],
);

// --- 1. ระบบ Login / Logout ---

Future<void> loginWithGoogle(BuildContext context) async {
  try {
    debugPrint('เริ่มกระบวนการ Login...');
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    Map<String, dynamic> requestBody;

    if (googleAuth.idToken != null) {
      requestBody = {'token': googleAuth.idToken};
    } else {
      requestBody = {
        'email': googleUser.email,
        'name': googleUser.displayName,
        'picture': googleUser.photoUrl,
        'google_id': googleUser.id,
      };
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api_login_google_app.php'),
      headers: apiHeaders,
      body: jsonEncode(requestBody),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        currentUser = jsonResponse['user'];
        userChanged.notifyListeners();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ยินดีต้อนรับคุณ ${currentUser!['name']}', style: const TextStyle(fontFamily: 'Kanit')),
            backgroundColor: const Color(0xFF6A806A),
          ),
        );
      }
    }
  } catch (error) {
    debugPrint('Login Error: $error');
  }
}

Future<void> logout() async {
  await _googleSignIn.signOut();
  currentUser = null;
  userChanged.notifyListeners();
}

// --- 2. ระบบดึงข้อสอบ & บันทึกคะแนน ---

void getTesting({String mode = 'practice'}) async {
  try {
    final result = await http.get(
      Uri.parse('$baseUrl/api_exams.php?mode=$mode'),
      headers: apiHeaders,
    );

    if (result.statusCode == 200) {
      final List json = jsonDecode(result.body);
      testings.clear();
      for (int i = 0; i < json.length; i++) {
        var item = json[i];
        List options = item['options'];
        int correctIndex = options.indexWhere((opt) => opt['is_correct'] == 1 || opt['is_correct'] == "1");

        testings.add({
          'id': item['id'],
          'topic': i,
          'question': item['question_text'],
          'img': item['question_image'],
          'ref': item['reference_text'],
          'detail_url': item['detail_url'],
          'options': options,
          'answer': correctIndex + 1,
          'answer_user': '0',
        });
      }
      testingsChanged.notifyListeners();
    }
  } catch (e) {
    debugPrint('Error getTesting: $e');
  }
}

Future<void> saveExamScore({
  required int score,
  required int total,
  required int duration,
}) async {
  if (currentUser == null) return;
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api_save_score.php'),
      headers: apiHeaders,
      body: jsonEncode({
        'email': currentUser!['email'],
        'subject': 'แอปพลิเคชัน',
        'score': score,
        'total': total,
        'duration': duration,
      }),
    );
    final result = jsonDecode(response.body);
    if (result['status'] == 'success') {
      debugPrint('บันทึกคะแนนสำเร็จ');
    }
  } catch (e) {
    debugPrint('Error saveExamScore: $e');
  }
} // ปิดปีกกาให้ถูกต้องแล้ว

// --- 3. ประวัติการสอบ & ทำเนียบคนเก่ง ---

Future<void> getHistory() async {
  if (currentUser == null) return;
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api_history.php?email=${currentUser!['email']}'),
      headers: apiHeaders,
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        historyList.clear();
        historyList.addAll(json['data']);
        historyChanged.value++;
      }
    }
  } catch (e) {
    debugPrint('Error getHistory: $e');
  }
}

Future<void> getLeaderboard() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api_leaderboard.php'),
      headers: apiHeaders,
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        leaderboardList = json['data'];
        leaderboardChanged.value++;
      }
    }
  } catch (e) {
    debugPrint('Leaderboard Error: $e');
  }
}

// --- 4. ดึงข้อมูลเบ็ดเตล็ด ---

void getWord() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_get_word.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        word = jsonResponse['data']['word'] ?? '';
        wordChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Exception getWord: $e'); }
}

void getNews() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_get_announcement.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        news.clear(); 
        if (jsonResponse['data'] != null) {
          news.add({'news': jsonResponse['data']['message'], 'ref': jsonResponse['data']['link_url']});
        }
        newsChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Exception getNews: $e'); }
}

void getPredict() async {
  // เพิ่มฟังก์ชันเสี่ยงทายไว้ให้ตามตัวแปรด้านบนครับ
  try {
    final result = await http.get(Uri.parse('$baseUrl/api_get_fortune.php'), headers: apiHeaders);
    final json = jsonDecode(result.body);
    if (json['status'] == 'success') {
      predictNumber = json['data']['id'].toString();
      predictResult = json['data']['result'];
      predictNumberChanged.notifyListeners();
      predictResultChanged.notifyListeners();
    }
  } catch (e) {
    debugPrint('Error getPredict: $e');
  }
}

// วางไว้ใน app_store.dart
String formatDuration(dynamic secondsInput) {
  int totalSeconds = int.tryParse(secondsInput.toString()) ?? 0;
  if (totalSeconds == 0) return '0 วินาที';
  
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  
  if (minutes == 0) return '$seconds วินาที';
  return '$minutes นาที $seconds วินาที';
}


// วางไว้ใน app_store.dart
String formatThaiDate(String dateString) {
  if (dateString.isEmpty) return "";
  
  try {
    DateTime date = DateTime.parse(dateString);
    
    // รายชื่อเดือนไทย
    const List<String> monthNames = [
      "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.",
      "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."
    ];

    int day = date.day;
    String month = monthNames[date.month - 1];
    int year = date.year + 543; // แปลง ค.ศ. เป็น พ.ศ.
    
    // ดึงเวลามาด้วยถ้าต้องการ (HH:mm น.)
    String time = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    return "$day $month $year • $time น.";
  } catch (e) {
    return dateString; // ถ้าแปลงไม่ได้ ให้ส่งค่าเดิมกลับไป
  }
}