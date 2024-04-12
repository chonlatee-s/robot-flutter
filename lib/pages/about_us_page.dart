import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            floating: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'เกี่ยวกับเรา',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(252, 252, 252, 1),
                ),
              ),
              background: Image.asset(
                'assets/img/about.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 20),
              child: Column(
                children: [
                  const Text(
                    'แอปพลิเคชันนี้จัดทำขึ้นเพื่อให้ผู้ที่กำลังเตรียมตัวสอบเข้าทำงานในหน่วยงานราชการ หรือรัฐวิสาหกิจ ที่เกี่ยวข้องกับสาขาวิชาคอมพิวเตอร์และเทคโนโลยีสารสนเทศ ข้อสอบเหล่านี้ได้ถูกรวบรวมมาจากผู้ที่มีประสบการณ์การสอบมานับครั้งไม่ถ้วน จากหลากหลายสังกัด นอกจากนี้ ข้อสอบมีการปรับปรุง แก้ไข เพิ่มเติมอย่างต่อเนื่อง เพื่อให้ทันต่อสถานการณ์ปัจจุบัน',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(41, 41, 41, 1),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 50),
                    child: Text(
                      'หากพบข้อผิดพลาด หรือมีคำแนะนำ ติดต่อที่ kruchonlatee@gmail.com ขอบคุณรูปหน้าปกสวย ๆ จาก freepik.com',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(41, 41, 41, 1),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => launchUrl(
                      Uri.parse('https://xn--o3cdd5af5d5a4j.com/'),
                    ),
                    child: const Text(
                      'ข้อมูลเพิ่มเติม นายโรบอท.com',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Color.fromRGBO(221, 119, 81, 1),
                        fontFamily: 'Kanit',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          currentIndex: 1,
          onTap: (int index) {
            if (index == 0) context.go('/home');
          },
          selectedItemColor: const Color.fromRGBO(70, 112, 96, 1),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
