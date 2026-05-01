import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robot/store/app_store.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 1. Import โฆษณา

class ExamModePage extends StatefulWidget {
  const ExamModePage({super.key});

  @override
  State<ExamModePage> createState() => _ExamModePageState();
}

class _ExamModePageState extends State<ExamModePage> {
  // 2. ตัวแปรสำหรับจัดการโฆษณา
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // ID สำหรับทดสอบ (อย่าลืมเปลี่ยนเป็น ID จริงตอนปล่อยแอปนะครับ)
  final String adUnitId = 'ca-app-pub-5901161227057601/7244214360'; // ของจริง admob
  // final String adUnitId = 'ca-app-pub-3940256099942544/6300978111'; // ตัวทดสอบ

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // ทำลายโฆษณาเมื่อออกจากหน้าเพื่อประหยัด RAM
    super.dispose();
  }

  // ฟังก์ชันโหลดโฆษณา
  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      appBar: AppBar(
        title: const Text('เลือกโหมดการสอบ', style: TextStyle(fontFamily: 'Kanit')),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF2D2F31),
      ),
      body: ListenableBuilder(
        listenable: userChanged,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // การ์ดโหมดแข่งขัน
                _buildModeCard(
                  context,
                  title: 'โหมดแข่งขัน',
                  subtitle: 'จับเวลาจริง บันทึกคะแนนลงทำเนียบคนเก่ง',
                  icon: Icons.emoji_events_rounded,
                  color: const Color(0xFFB15731),
                  isLocked: currentUser == null,
                  onTap: () async {
                    if (currentUser == null) {
                      await loginWithGoogle(context);
                      if (currentUser != null) {
                        getTesting(mode: 'competition');
                        if (context.mounted) context.pushReplacement('/testing');
                      }
                    } else {
                      getTesting(mode: 'competition');
                      context.push('/testing');
                    }
                  },
                ),
                const SizedBox(height: 20),
                // การ์ดโหมดฝึกฝน
                _buildModeCard(
                  context,
                  title: 'โหมดฝึกฝน',
                  subtitle: 'สุ่มข้อสอบทำได้ไม่จำกัด พร้อมเฉลยละเอียด',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF6A806A),
                  onTap: () {
                    getTesting(mode: 'practice');
                    context.push('/testing');
                  },
                ),
                if (currentUser != null) ...[
                  const SizedBox(height: 30),
                  Text(
                    'ล็อกอินในชื่อ: ${currentUser!['name']}',
                    style: const TextStyle(fontFamily: 'Kanit', fontSize: 13, color: Colors.grey),
                  ),
                ]
              ],
            ),
          );
        },
      ),
      // 3. วางโฆษณาใน bottomNavigationBar เพื่อให้ชิดขอบล่างสุดพอดี
      bottomNavigationBar: _isLoaded && _bannerAd != null
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 5), // เพิ่มช่องว่างเล็กน้อยถ้าต้องการ
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildModeCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: isLocked ? Colors.grey.shade300 : color.withOpacity(0.5),
              width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: isLocked ? Colors.grey.shade200 : color.withOpacity(0.1),
              child: Icon(isLocked ? Icons.lock_outline : icon,
                  color: isLocked ? Colors.grey : color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : const Color(0xFF2D2F31),
                    ),
                  ),
                  Text(
                    isLocked ? 'กรุณาเข้าสู่ระบบเพื่อปลดล็อก' : subtitle,
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}