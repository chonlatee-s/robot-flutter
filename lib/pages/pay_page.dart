import 'package:flutter/material.dart';

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เลี้ยงชานมไข่มุก',
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
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/qr.png',
                    width: 170,
                  ),
                  SelectableText(
                    '0827818941',
                    onSelectionChanged: (selection, cause) {},
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(218, 84, 67, 1),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ชื่อบัญชี',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(41, 41, 41, 1),
                          ),
                        ),
                        Text(
                          'ชลธี  สินสาตร์',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(218, 84, 67, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 123, 123, 123),
                    height: 50,
                    thickness: 0.2,
                  ),
                  const Row(
                    children: [
                      Text(
                        'ข้อความถึงคู่หู',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(41, 41, 41, 1),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          'ระลึกเสมอว่า การสอบครั้งนี้จะเป็นการเหนื่อยครั้งสุดท้ายของเธอแล้วจริง ๆ จงเชื่อมั่นในตัวเองนะ เธอทำได้ เธอทำได้ และเธอทำได้ ไว้มีโอกาสมาชนแก้วชานมไข่มุกเพื่อฉลองความสำเร็จไปด้วยกันนะ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Color.fromRGBO(41, 41, 41, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0.0),
                  topLeft: Radius.circular(0.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(178, 200, 135, 1),
                    Color.fromRGBO(70, 112, 96, 1),
                  ],
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'ขอบคุณที่ดูแลกันนะ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 31,
                      fontWeight: FontWeight.w200,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'เพราะร่างกายขาดชานมไข่มุกไม่ได้',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
