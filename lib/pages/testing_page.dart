import 'package:flutter/material.dart';
import 'package:robot/store/app_store.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  var _indexStack = 0;
  final _indexStackChanged = ChangeNotifier();
  var _index = 0;
  bool isVisibleNext = true;
  bool isVisiblePrev = false;
  final indexChanged = ChangeNotifier();
  bool isVisibleSentAnswer = false;
  var _progress = 0.0;
  var timeCount = '10.00 น.';
  late Timer _timer;
  final timeCountChanged = ChangeNotifier();
  var _score = 0;
  final scoreChanged = ChangeNotifier();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getTesting();
    getTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ทำข้อสอบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(124, 159, 127, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ListenableBuilder(
            listenable: Listenable.merge([
              testingsChanged,
              indexChanged,
              timeCountChanged,
              _indexStackChanged
            ]),
            builder: (BuildContext context, Widget? child) {
              return IndexedStack(
                index: _indexStack,
                children: [
                  // ทำข้อสอบ
                  Container(
                    width: double.infinity,
                    color: const Color.fromARGB(255, 249, 246, 242),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 40, left: 15, right: 15, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //command
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text.rich(
                              TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    color: Color.fromRGBO(103, 127, 86, 1),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'คำชี้แจง',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w400,
                                        decorationColor:
                                            Color.fromRGBO(103, 127, 86, 1),
                                        decorationThickness: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' : เลือกคำตอบที่ถูกต้องที่สุดเพียงข้อเดียว',
                                    )
                                  ]),
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 123, 123, 123),
                            height: 20,
                            thickness: 0.1,
                            indent: 10,
                            endIndent: 10,
                          ),

                          // time
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ข้อ ${_index + 1} / ${testings.length}',
                                  style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(103, 127, 86, 1),
                                  ),
                                ),
                                Text(
                                  timeCount,
                                  style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(103, 127, 86, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // progress
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Row(
                              children: [
                                LinearPercentIndicator(
                                  width: MediaQuery.of(context).size.width - 30,
                                  lineHeight: 8.0,
                                  percent: _progress,
                                  backgroundColor:
                                      const Color.fromARGB(255, 199, 199, 199),
                                  progressColor:
                                      const Color.fromRGBO(178, 200, 135, 1),
                                )
                              ],
                            ),
                          ),

                          // question and choice
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, bottom: 15, right: 15),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: const Color.fromARGB(255, 222, 222, 222),
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(94, 93, 93, 0.2),
                                    blurRadius: 5.0,
                                    offset: Offset(0.0, 0.20))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //question
                                Visibility(
                                  visible: testings.isNotEmpty
                                      ? testings[_index]['img'] == ''
                                          ? false
                                          : true
                                      : false,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.75,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              topRight: Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Center(
                                              child: Image.network(
                                                  testings[_index]['img'],
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color:
                                                Color.fromRGBO(124, 38, 27, 1),
                                          ),
                                          Text(
                                            ' คลิกที่นี่เพื่อดูรป',
                                            style: TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Color.fromRGBO(
                                                  124, 38, 27, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  testings.isEmpty
                                      ? '?'
                                      : testings[_index]['question'],
                                  style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(41, 41, 41, 1),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                //choice 1
                                InkWell(
                                  onTap: () {
                                    getAnswer('1');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        bottom: 10,
                                        right: 5),
                                    decoration: BoxDecoration(
                                      color: (testings.isNotEmpty &&
                                              testings[_index]['answer_user'] ==
                                                  '1')
                                          ? const Color.fromRGBO(
                                              239, 140, 122, 1)
                                          : const Color.fromARGB(
                                              255, 250, 248, 248),
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '1')
                                            ? const Color.fromRGBO(
                                                239, 140, 122, 1)
                                            : const Color.fromARGB(
                                                255, 222, 222, 222),
                                      ),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                216, 216, 216, 0.2),
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 0.20))
                                      ],
                                    ),
                                    child: Text(
                                      testings.isEmpty
                                          ? '?'
                                          : 'ก. ${testings[_index]['ch1']}',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '1')
                                            ? const Color.fromRGBO(
                                                255, 255, 255, 1)
                                            : const Color.fromRGBO(
                                                41, 41, 41, 1),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //choice 2
                                InkWell(
                                  onTap: () {
                                    getAnswer('2');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        bottom: 10,
                                        right: 5),
                                    decoration: BoxDecoration(
                                      color: (testings.isNotEmpty &&
                                              testings[_index]['answer_user'] ==
                                                  '2')
                                          ? const Color.fromRGBO(
                                              239, 140, 122, 1)
                                          : const Color.fromARGB(
                                              255, 250, 248, 248),
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '2')
                                            ? const Color.fromRGBO(
                                                239, 140, 122, 1)
                                            : const Color.fromARGB(
                                                255, 222, 222, 222),
                                      ),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                216, 216, 216, 0.2),
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 0.20))
                                      ],
                                    ),
                                    child: Text(
                                      testings.isEmpty
                                          ? '?'
                                          : 'ข. ${testings[_index]['ch2']}',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '2')
                                            ? const Color.fromRGBO(
                                                255, 255, 255, 1)
                                            : const Color.fromRGBO(
                                                41, 41, 41, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //choice 3
                                InkWell(
                                  onTap: () {
                                    getAnswer('3');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        bottom: 10,
                                        right: 5),
                                    decoration: BoxDecoration(
                                      color: (testings.isNotEmpty &&
                                              testings[_index]['answer_user'] ==
                                                  '3')
                                          ? const Color.fromRGBO(
                                              239, 140, 122, 1)
                                          : const Color.fromARGB(
                                              255, 250, 248, 248),
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '3')
                                            ? const Color.fromRGBO(
                                                239, 140, 122, 1)
                                            : const Color.fromARGB(
                                                255, 222, 222, 222),
                                      ),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                216, 216, 216, 0.2),
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 0.20))
                                      ],
                                    ),
                                    child: Text(
                                      testings.isEmpty
                                          ? '?'
                                          : 'ค. ${testings[_index]['ch3']}',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '3')
                                            ? const Color.fromRGBO(
                                                255, 255, 255, 1)
                                            : const Color.fromRGBO(
                                                41, 41, 41, 1),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                //choice 4
                                InkWell(
                                  onTap: () {
                                    getAnswer('4');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        bottom: 10,
                                        right: 5),
                                    decoration: BoxDecoration(
                                      color: (testings.isNotEmpty &&
                                              testings[_index]['answer_user'] ==
                                                  '4')
                                          ? const Color.fromRGBO(
                                              239, 140, 122, 1)
                                          : const Color.fromARGB(
                                              255, 250, 248, 248),
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '4')
                                            ? const Color.fromRGBO(
                                                239, 140, 122, 1)
                                            : const Color.fromARGB(
                                                255, 222, 222, 222),
                                      ),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                216, 216, 216, 0.2),
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 0.20))
                                      ],
                                    ),
                                    child: Text(
                                      testings.isEmpty
                                          ? '?'
                                          : 'ง. ${testings[_index]['ch4']}',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: (testings.isNotEmpty &&
                                                testings[_index]
                                                        ['answer_user'] ==
                                                    '4')
                                            ? const Color.fromRGBO(
                                                255, 255, 255, 1)
                                            : const Color.fromRGBO(
                                                41, 41, 41, 1),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 40,
                                ),

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Visibility(
                                        visible: isVisiblePrev,
                                        child: IconButton(
                                          onPressed: () {
                                            prevStep();
                                          },
                                          icon: const Icon(Icons.arrow_back),
                                        ),
                                      ),
                                      const Text(
                                        'กดลูกศรเพื่อข้ามหรือย้อนกลับ',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(41, 41, 41, 1),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isVisibleNext,
                                        child: IconButton(
                                          onPressed: () {
                                            nextStep();
                                          },
                                          icon: const Icon(Icons.arrow_forward),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ปุ่มส่งคำตอบ
                          Visibility(
                            visible: isVisibleSentAnswer,
                            child: InkWell(
                              onTap: () {
                                checkAnswer();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 30),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromRGBO(178, 200, 135, 1),
                                        Color.fromRGBO(70, 112, 96, 1),
                                      ],
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'ตรวจคำตอบ',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'เฉลยคำตอบ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(41, 41, 41, 1),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'คะแนนที่ได้',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(218, 84, 67, 1),
                              ),
                            ),
                            Text(
                              '$_score / 10',
                              style: const TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(218, 84, 67, 1),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 123, 123, 123),
                          height: 30,
                          thickness: 0.2,
                        ),
                        showAnswer(),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void nextStep() {
    if (_index < testings.length - 1) {
      _index++;
      isVisiblePrev = true;
    }
    if (_index == testings.length - 1) isVisibleNext = false;
    indexChanged.notifyListeners();
  }

  void prevStep() {
    if (_index > 0) {
      _index--;
      isVisibleNext = true;
    }
    if (_index == 0) isVisiblePrev = false;

    indexChanged.notifyListeners();
  }

  void getAnswer(String ans) {
    // set คำตอบใหม่ทุกครั้ง
    testings[_index]['answer_user'] = ans;
    nextStep();
    checkProgress();
  }

  void checkProgress() {
    var check = 0;
    var progress = 0.0;
    for (int i = 0; i < testings.length; i++) {
      if (testings[i]['answer_user'] == '0') {
        check++;
      } else {
        progress += 0.1;
      }
    }
    if (check == 0) isVisibleSentAnswer = true;
    _progress = progress;
  }

  void getTime() {
    const duration = Duration(minutes: 10); // กำหนดระยะเวลา 10 นาที
    int countdown = duration.inSeconds; // นับถอยหลังในหน่วยวินาที

    // เริ่มตัวนับเวลา
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        timer.cancel(); // หยุดตัวนับเวลาเมื่อนับถอยหลังเสร็จสิ้น
        // print('เวลาหมดแล้ว!');
        timeCount = 'หมดเวลา';
        timeCountChanged.notifyListeners();
        checkAnswer();
      } else {
        int minutes = countdown ~/ 60; // หานาที
        int seconds = countdown % 60; // หาวินาทีที่เหลือ
        // print('$minutes:${seconds.toString().padLeft(2, '0')}');
        timeCount = '$minutes:${seconds.toString().padLeft(2, '0')} น.';
        timeCountChanged.notifyListeners();
        countdown--;
      }
    });
    // print('เริ่มตัวนับเวลา...');
  }

  void checkAnswer() {
    var sum = 0;
    _indexStack = 1;
    _indexStackChanged.notifyListeners();

    for (int i = 0; i < testings.length; i++) {
      if (testings[i]['answer_user'] == testings[i]['answer']) {
        sum++;
      }
    }
    _score = sum;
    scoreChanged.notifyListeners();
    _timer.cancel();
  }

  Widget showAnswer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...testings.map(
          (item) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: item['img'] == '' ? false : true,
                child: Image.network(
                  item['img'],
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                'ข้อ ${item['topic'] + 1} ${item['question']}',
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(41, 41, 41, 1),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              (item['answer_user'] == '1')
                  ? styleAnswer(item['topic'], '1', 'ตอบ')
                  : (item['answer_user'] == '2')
                      ? styleAnswer(item['topic'], '2', 'ตอบ')
                      : (item['answer_user'] == '3')
                          ? styleAnswer(item['topic'], '3', 'ตอบ')
                          : (item['answer_user'] == '4')
                              ? styleAnswer(item['topic'], '4', 'ตอบ')
                              : styleAnswer(item['topic'], '0', 'ตอบ'),
              const SizedBox(
                height: 3,
              ),
              (item['answer_user'] != item['answer'])
                  ? styleAnswer(item['topic'], item['answer'], 'เฉลย')
                  : const Visibility(
                      visible: false,
                      child: Text(''),
                    ),
              const Divider(
                color: Color.fromARGB(255, 123, 123, 123),
                height: 25,
                thickness: 0.1,
              ),
            ],
          ),
        ), //just in case you want to build from list of items as you would do in ListView.builder
      ],
    );
  }

  Widget styleAnswer(topic, answer, txt) {
    return Text.rich(
      TextSpan(
          style: const TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Color.fromARGB(255, 98, 98, 98),
          ),
          children: [
            TextSpan(
              text: txt,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Color.fromARGB(255, 98, 98, 98),
                decorationThickness: 1,
              ),
            ),
            TextSpan(
              text: (answer == '0')
                  ? ' หมดเวลา ไม่ตอบคำถาม'
                  : ' ${testings[topic]['ch$answer']}',
            )
          ]),
    );
  }
}
