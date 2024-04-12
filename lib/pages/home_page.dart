import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robot/store/app_store.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    getNews();
    getWord();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/img/logo_home.png',
              width: 90,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: ListenableBuilder(
            listenable: Listenable.merge([newsChanged, wordChanged]),
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => launchUrl(
                        Uri.parse((news.isNotEmpty) ? news[0]['ref'] : '?'),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 30),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    size: 30,
                                    Icons.notifications_active,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: Text(
                                      (news.isNotEmpty) ? news[0]['news'] : '?',
                                      style: const TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    size: 25,
                                    Icons.arrow_forward,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สวัสดี, คู่หู',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: <Color>[
                                      Color.fromRGBO(221, 119, 81, 1),
                                      Color.fromRGBO(218, 49, 139, 1),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                  ),
                              ),
                            ),
                            Text(
                              (word.isNotEmpty) ? word : '?',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: <Color>[
                                      Color.fromARGB(255, 39, 35, 40),
                                      Color.fromARGB(255, 96, 83, 94),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                  ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 45, bottom: 10),
                          child: Text(
                            'รายการ',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(41, 41, 41, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context.push('/testing');
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.edit_note,
                                        color: Color.fromRGBO(187, 190, 170, 1),
                                        size: 35,
                                      ),
                                      Text(
                                        'ฝึกทำข้อสอบ',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(41, 41, 41, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.push('/agenda');
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.category,
                                        color: Color.fromRGBO(187, 190, 170, 1),
                                        size: 35,
                                      ),
                                      Text(
                                        'เกณฑ์สอบ',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(41, 41, 41, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.push('/guideline');
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.article,
                                        color: Color.fromRGBO(187, 190, 170, 1),
                                        size: 35,
                                      ),
                                      Text(
                                        'แนวข้อสอบ',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(41, 41, 41, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => launchUrl(
                                    Uri.parse(
                                        'https://www.youtube.com/@user-um9cq5or4v/playlists'),
                                  ),
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.rocket_launch,
                                        color: Color.fromRGBO(187, 190, 170, 1),
                                        size: 35,
                                      ),
                                      Text(
                                        'เรียนออนไลน์',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.push('/pay');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.coffee,
                                        color: Color.fromRGBO(187, 190, 170, 1),
                                        size: 35,
                                      ),
                                      Text(
                                        'เลี้ยงชาไข่มุก',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(41, 41, 41, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/testing');
        },
        tooltip: 'ทำข้อสอบ',
        child: const Icon(
          Icons.edit_note,
          size: 40,
          color: Color.fromRGBO(48, 71, 51, 1),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'เกี่ยวกับเรา',
            ),
          ],
          onTap: (int index) {
            if (index == 1) context.go('/aboutUs');
          },
          selectedItemColor: const Color.fromRGBO(70, 112, 96, 1),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
