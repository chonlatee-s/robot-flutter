import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    loading(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(131, 150, 133, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/logo.png',
                    width: 120,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'นายโรบอท',
                      style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 37,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'แนวข้อสอบ เอกคอมพิวเตอร์',
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 200, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromRGBO(131, 150, 133, 1),
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'กำลังดาวน์โหลดข้อมูล',
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  loading(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      context.go('/home');
    });
  }
}
