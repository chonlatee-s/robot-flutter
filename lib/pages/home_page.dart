import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robot/store/app_store.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryGreen = Color(0xFF6A806A);
  static const Color accentOrange = Color(0xFFB15731);
  static const Color darkText = Color(0xFF2D2F31);

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลเริ่มต้นเมื่อเปิดแอป
    getNews();
    getWord();
    getLeaderboard(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset(
            'assets/img/logo_home.png',
            width: 90,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: userChanged,
            builder: (context, child) {
              if (currentUser == null) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => _showLogoutDialog(context),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: currentUser!['picture'] != null 
                        ? NetworkImage(currentUser!['picture']) 
                        : null,
                    child: currentUser!['picture'] == null 
                        ? const Icon(Icons.person, size: 20) 
                        : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListenableBuilder(
          listenable: Listenable.merge([newsChanged, wordChanged, userChanged]),
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. ประกาศข่าวสาร
                      if (news.isNotEmpty) _buildCleanNewsBanner(context, news[0]),

                      const SizedBox(height: 24),

                      // 2. ส่วนทักทาย
                      _buildGreetingSection(),
                      
                      const SizedBox(height: 30),

                      // 3. กล่องทำข้อสอบ Hero Card
                      _buildHeroExamCard(context),

                      const SizedBox(height: 35),

                      const Text(
                        'บริการทั้งหมด',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. ตารางเมนู (Action Grid)
                      _buildMenuGrid(context),
                      
                      const SizedBox(height: 35),

                      // 5. ทำเนียบคนเก่ง (Leaderboard)
                      _buildLeaderboardSection(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/exam-mode'),
        backgroundColor: primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.edit_note,
          size: 32,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentUser != null ? 'ยินดีต้อนรับ, คุณ${currentUser!['name']}' : 'สวัสดี, คู่หู',
          style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          word.isNotEmpty ? word : 'ขอให้วันนี้เป็นวันที่ดีในการเรียนรู้นะ',
          style: const TextStyle(
            fontFamily: 'Kanit',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: accentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroExamCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accentOrange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE97451), Color(0xFFB15731)],
              ),
            ),
            child: InkWell(
              onTap: () => context.push('/exam-mode'),
              child: Stack(
                children: [
                  Positioned(
                    right: 20,
                    bottom: 35,
                    child: Icon(Icons.psychology, size: 100, color: Colors.white.withOpacity(0.15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'เริ่มทำข้อสอบ',
                          style: TextStyle(fontFamily: 'Kanit', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ตะลุยโจทย์เพื่อความแม่นยำ',
                          style: TextStyle(fontFamily: 'Kanit', fontSize: 14, color: Colors.white.withOpacity(0.9)),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                          child: const Text(
                            'เริ่มเลย',
                            style: TextStyle(fontFamily: 'Kanit', fontSize: 12, fontWeight: FontWeight.bold, color: accentOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(context, Icons.history, 'ประวัติการสอบ', () {
            if (currentUser == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('กรุณาเข้าสู่ระบบเพื่อดูประวัติ', style: TextStyle(fontFamily: 'Kanit'))),
              );
              context.push('/exam-mode');
            } else {
              context.push('/history');
            }
          }),
          _buildMenuItem(context, Icons.rocket_launch_outlined, 'เรียนออนไลน์', () => launchUrl(Uri.parse('https://www.youtube.com/@นายโรบอท'))),
          _buildMenuItem(context, Icons.auto_awesome, 'เว็บไซต์', () => launchUrl(Uri.parse('https://xn--o3cdd5af5d5a4j.com'))),
          _buildMenuItem(context, Icons.coffee_outlined, 'เลี้ยงชาไข่มุก', () => context.push('/pay')),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: primaryGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(50)),
            child: Icon(icon, color: primaryGreen, size: 30),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontFamily: 'Kanit', fontSize: 11, color: darkText)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ทำเนียบคนเก่ง',
          style: TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.bold, color: darkText),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: leaderboardChanged,
          builder: (context, value, child) {
            if (leaderboardList.isEmpty) {
              return const Center(child: Text('กำลังโหลดข้อมูล...', style: TextStyle(fontFamily: 'Kanit', fontSize: 12)));
            }
            return Column(
              children: leaderboardList.asMap().entries.map((entry) {
                int index = entry.key;
                var user = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: primaryGreen)),
                      const SizedBox(width: 12),
                      CircleAvatar(radius: 20, backgroundImage: NetworkImage(user['google_profile_pic'])),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user['user_name'],
                          style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${user['top_score']} แต้ม', style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold, color: accentOrange)),
                          Text(
                            'เวลา: ${formatDuration(user['best_time'])}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'Kanit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCleanNewsBanner(BuildContext context, dynamic currentNews) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(currentNews['ref'] ?? '')),
        child: Row(
          children: [
            const Icon(Icons.campaign_outlined, color: Colors.green, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${currentNews['news'] ?? ''}',
                style: const TextStyle(fontFamily: 'Kanit', fontSize: 13, color: Colors.green),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, color: primaryGreen, size: 26),
              Text('หน้าหลัก', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: primaryGreen, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 40),
          InkWell(
            onTap: () => context.go('/aboutUs'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, color: Colors.grey[400], size: 26),
                Text('ผู้พัฒนา', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ?', style: TextStyle(fontFamily: 'Kanit')),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?', style: TextStyle(fontFamily: 'Kanit')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(onPressed: () { logout(); Navigator.pop(context); }, child: const Text('ตกลง', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}