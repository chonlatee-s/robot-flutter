import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:robot/store/app_store.dart';
import '../services/ad_helper.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isFinished = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _secondsSpent = 0;

  // สีตามธีมนายโรบอท
  final Color primaryGreen = const Color(0xFF6A806A);
  final Color accentOrange = const Color(0xFFB15731);
  final Color darkNavy = const Color(0xFF2D2F31);
  final Color bgLight = const Color(0xFFF8F9F8);

  @override
  void initState() {
    super.initState();
    AdHelper.loadInterstitialAd();
    // กำหนดเวลา: โหมดแข่งขัน (Login แล้ว) 20 นาที / ฝึกฝน 10 นาที
    _remainingSeconds = (currentUser != null) ? 20 * 60 : 10 * 60;
    _startTimer();
    _initData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _secondsSpent++;
        });
      } else {
        _timer?.cancel();
        _finishExam();
      }
    });
  }

  void _initData() {
    if (testings.isNotEmpty) {
      setState(() => _isLoading = false);
    } else {
      testingsChanged.addListener(_onDataLoaded);
    }
  }

  void _onDataLoaded() {
    if (mounted && testings.isNotEmpty) {
      setState(() => _isLoading = false);
      testingsChanged.removeListener(_onDataLoaded);
    }
  }

  void _finishExam() {
    _timer?.cancel();
    int score = 0;
    for (var item in testings) {
      if (item['answer_user'].toString() == item['answer'].toString()) {
        score++;
      }
    }

    // บันทึกคะแนนเฉพาะโหมดแข่งขัน
    if (currentUser != null) {
      saveExamScore(
        score: score,
        total: testings.length,
        duration: _secondsSpent,
      );
    }

    setState(() => _isFinished = true);
    _showResultDialog(score, testings.length);
  }

  void _showResultDialog(int score, int limit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text('สรุปผลการสอบ',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$score / $limit',
                style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen)),
            const Text('คะแนนที่ทำได้',
                style: TextStyle(fontFamily: 'Kanit', color: Colors.grey)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 1. สั่งแสดงโฆษณาก่อน
                AdHelper.showInterstitialAd(() {
                  // 2. เมื่อปิดโฆษณา หรือโฆษณาโหลดไม่ขึ้น ให้ทำคำสั่งข้างล่างนี้
                  Navigator.pop(context); // ปิด Dialog สรุปผล
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: darkNavy,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: const Text('ดูเฉลยละเอียด',
                  style: TextStyle(color: Colors.white, fontFamily: 'Kanit')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: primaryGreen,
        body: const Center(
            child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (_isFinished) return _buildReviewView();

    final q = testings[_currentIndex];
    double progress = (_currentIndex + 1) / testings.length;

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text(currentUser != null ? 'โหมดแข่งขัน' : 'โหมดฝึกฝน',
            style: const TextStyle(
                fontFamily: 'Kanit',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: darkNavy, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit'),
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: darkNavy,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressBar(progress),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildQuestionCard(q),
                  const SizedBox(height: 20),
                  ...(q['options'] as List).asMap().entries.map((entry) {
                    int idx = entry.key + 1;
                    String label = String.fromCharCode(64 + idx); // A, B, C, D
                    bool isSelected =
                        q['answer_user'].toString() == idx.toString();
                    return _buildOption(
                        idx, label, entry.value['option_text'], isSelected);
                  }).toList(),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ความก้าวหน้า ${_currentIndex + 1}/${testings.length}',
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 12,
                      color: Colors.grey[600])),
              Text('${(progress * 100).toInt()}%',
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 12,
                      color: primaryGreen,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: primaryGreen.withOpacity(0.1),
                color: primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(dynamic q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ข้อที่ ${_currentIndex + 1}',
              style: TextStyle(
                  fontFamily: 'Kanit',
                  color: accentOrange,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(q['question'] ?? '',
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkNavy,
                  height: 1.5)),
          if (q['img'] != null && q['img'] != "") ...[
            const SizedBox(height: 15),
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(q['img'])),
          ]
        ],
      ),
    );
  }

  Widget _buildOption(int idx, String label, String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => testings[_currentIndex]['answer_user'] = idx.toString());
        if (_currentIndex < testings.length - 1) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _currentIndex++);
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? primaryGreen : Colors.grey.shade100,
              width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primaryGreen.withOpacity(0.1), blurRadius: 10)
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: isSelected ? primaryGreen : bgLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(label,
                      style: TextStyle(
                          color: isSelected ? Colors.white : darkNavy,
                          fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 15),
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        fontFamily: 'Kanit', color: darkNavy, fontSize: 15))),
          ],
        ),
      ),
    );
  }

 Widget _buildBottomNav() {
    return Container(
      // 1. ใส่สีพื้นหลังให้ Container ชั้นนอกสุดเพื่อให้ SafeArea ดูเนียน
      color: Colors.white, 
      child: SafeArea(
        // 2. ใช้ SafeArea ครอบเฉพาะด้านล่าง (bottom: true เป็นค่าเริ่มต้น)
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), // ปรับ padding ให้สมดุล
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                TextButton.icon(
                  onPressed: () => setState(() => _currentIndex--),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('ข้อก่อนหน้า', style: TextStyle(fontFamily: 'Kanit')),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                )
              else
                const SizedBox(),
              ElevatedButton(
                onPressed: () => _currentIndex == testings.length - 1 
                    ? _finishExam() 
                    : setState(() => _currentIndex++),
                style: ElevatedButton.styleFrom(
                    backgroundColor: darkNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text(_currentIndex == testings.length - 1 ? 'ส่งข้อสอบ' : 'ข้อถัดไป',
                    style: const TextStyle(fontFamily: 'Kanit', color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewView() {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text('เฉลยละเอียด',
            style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: darkNavy,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: testings.length,
        itemBuilder: (context, index) {
          final q = testings[index];
          return _buildReviewItem(index, q);
        },
      ),
    );
  }

  Widget _buildReviewItem(int index, dynamic q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ข้อที่ ${index + 1}',
              style: TextStyle(
                  fontFamily: 'Kanit',
                  color: primaryGreen,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(q['question'] ?? '',
              style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ...(q['options'] as List).asMap().entries.map((entry) {
            int optIdx = entry.key + 1;
            bool isCorrect = q['answer'].toString() == optIdx.toString();
            bool isUser = q['answer_user'].toString() == optIdx.toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.shade50
                    : (isUser ? Colors.red.shade50 : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isCorrect
                        ? Colors.green
                        : (isUser ? Colors.red : Colors.grey.shade100)),
              ),
              child: Row(
                children: [
                  Text(String.fromCharCode(64 + optIdx),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entry.value['option_text'])),
                  if (isCorrect)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 18),
                ],
              ),
            );
          }).toList(),
          if (q['ref'] != null && q['ref'] != "")
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: bgLight,
                  borderRadius: BorderRadius.circular(15),
                  border:
                      Border(left: BorderSide(color: primaryGreen, width: 4))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('คำอธิบาย: ${q['ref']}',
                      style: const TextStyle(fontFamily: 'Kanit', fontSize: 13)),
                  if (q['detail_url'] != null && q['detail_url'] != "")
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () => launchUrl(Uri.parse(q['detail_url'])),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'อ่านรายละเอียดเพิ่มเติม ',
                              style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 12,
                                  color: accentOrange,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            Icon(Icons.open_in_new,
                                size: 14, color: accentOrange),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
        ],
      ),
    );
  }
}