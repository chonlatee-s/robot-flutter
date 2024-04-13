import 'dart:async';
import 'package:flutter/material.dart';
import 'package:robot/store/app_store.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  bool isVisible = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    loadPredict();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เซียมซีเสี่ยงทาย',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(124, 159, 127, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: isVisible,
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 250, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: Color.fromRGBO(124, 159, 127, 1),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'กำลังเสี่ยงทาย',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(124, 159, 127, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !isVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                    child: Text(
                      'ผลการเสี่ยงทาย',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(41, 41, 41, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(25),
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
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ListenableBuilder(
                                    listenable: predictNumberChanged,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Text(
                                        'ใบที่ $predictNumber',
                                        style: const TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 30,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(41, 41, 41, 1),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: ListenableBuilder(
                                      listenable: predictResultChanged,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Text(
                                          predictResult,
                                          style: const TextStyle(
                                            fontFamily: 'Kanit',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Color.fromRGBO(41, 41, 41, 1),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Text(
                                    'ที่มา : วัดหนองบัว จังหวัดอุบลราชธานี',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(124, 159, 127, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      loadPredict();
                    },
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            loadPredict();
                          },
                          icon: const Icon(
                            Icons.favorite,
                            size: 50,
                            color: Color.fromARGB(255, 211, 48, 86),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Text(
                            'ลองอีกครั้ง',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 148, 28, 56),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadPredict() {
    setState(() {
      isVisible = true;
    });
    getPredict();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isVisible = false;
      });
    });
  }
}
