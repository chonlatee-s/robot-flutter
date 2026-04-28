import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // สีหลักของแอปนายโรบอท
  static const Color primaryGreen = Color(0xFF6A806A);
  static const Color lightGreen = Color(0xFFE8EDE8);
  static const Color darkText = Color(0xFF2D2F31);
  static const Color accentOrange = Color(0xFFB15731);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            elevation: 0,
            backgroundColor: primaryGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => context.go('/home'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/img/about.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: primaryGreen,
                      child: const Icon(Icons.person, size: 80, color: Colors.white24),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          primaryGreen.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              // ปรับ offset จาก -20 เป็น 10 เพื่อให้กล่องเลื่อนลงมา ไม่ทับรูปภาพจนเกินไป
              offset: const Offset(0, 10), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ประวัติการศึกษา', Icons.school_outlined),
                    _buildEducationContent(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ประสบการณ์ทำงาน', Icons.work_outline_rounded),
                    _buildWorkContent(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ความเชี่ยวชาญ & ผลงาน', Icons.verified_outlined),
                    _buildExpertiseContent(),
                    const SizedBox(height: 40),
                    const Opacity(
                      opacity: 0.4,
                      child: Text('นายโรบอท.com', style: TextStyle(fontFamily: 'Kanit', fontSize: 12)),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/testing'),
        backgroundColor: primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit_note, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      // เพิ่ม Padding ด้านบนจาก 24 เป็น 40 เพื่อให้ชื่อขยับลงมาด้านล่างมากขึ้น
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 24), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'ชลธี สินสาตร์',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'การศึกษาคือรากฐานของชีวิต',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 13,
              color: primaryGreen,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFF1F1F1), thickness: 1),
          ),
          _buildInfoRow(Icons.email_outlined, 'อีเมล : kruchonlatee@gmail.com'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.interests_outlined, 'สิ่งที่สนใจ : เทคโนโลยี, ธรรมะ, ภาษาและวัฒนธรรม'),
        ],
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
          InkWell(
            onTap: () => context.go('/home'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color:Colors.grey[400], size: 26),
                Text('หน้าหลัก', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color:Colors.grey[400])),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, color: primaryGreen, size: 26),
              Text('ผู้พัฒนา', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: primaryGreen, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: primaryGreen, size: 22),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Kanit',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTimelineItem(String year, String title, String sub, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: lightGreen,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(year, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryGreen)),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkText, fontFamily: 'Kanit')),
                Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Kanit')),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationContent() {
    return _buildContentCard([
      _buildTimelineItem('กำลังศึกษา ปริญญาโท', 'สาขาวิศวกรรมหุ่นยนต์ฯ คณะวิศวกรรมศาสตร์', 'สถาบันเทคโนโลยีพระจอมเกล้าลาดกระบัง', isLast: false),
      _buildTimelineItem('ESL', 'ESP Program', 'City College of San Francisco', isLast: false),
      _buildTimelineItem('ปริญญาตรี', 'สาขาเทคโนโลยีคอมพิวเตอร์ คณะครุศาสตร์อุตสาหกรรม', 'มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ', isLast: false),
      _buildTimelineItem('ปวส.', 'สาขาเทคโนโลยีสารสนเทศ', 'วิทยาลัยเทคนิคท่าหลวงซิเมนต์ไทยอนุสรณ์', isLast: true),
      _buildTimelineItem('ปวช.', 'สาขาช่างอิเล็กทรอนิสก์', 'วิทยาลัยเทคนิคเดชอุดม', isLast: true),
    ]);
  }

  Widget _buildWorkContent() {
    return _buildContentCard([
      _buildTimelineItem('ปัจจุบัน', 'ข้าราชการครู', 'วิทยาลัยเทคนิคชลบุรี', isLast: false),
      _buildTimelineItem('2565', 'Frontend Developer', 'Outsource Team AIS', isLast: false),
      _buildTimelineItem('2564', 'นักประมวลผลข้อมูล ระดับ 4', 'การไฟฟ้านครหลวง (MEA)', isLast: false),
      _buildTimelineItem('2561', 'ครูอาสาสมัครต่างประเทศ', 'โครงการครุศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย', isLast: true),
      _buildTimelineItem('2559', 'Full-stack Developer', 'Software House', isLast: false),
    ]);
  }

  Widget _buildExpertiseContent() {
    return _buildContentCard([
      _buildBulletItem('พัฒนาระบบสารสนเทศภาครัฐและเอกชน'),
      _buildBulletItem('วิทยากรด้านเทคโนโลยีสารสนเทศ'),
    ]);
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle_outline, size: 14, color: primaryGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, height: 1.5, fontFamily: 'Kanit', color: darkText.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: primaryGreen),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: darkText, fontFamily: 'Kanit'))),
      ],
    );
  }
}