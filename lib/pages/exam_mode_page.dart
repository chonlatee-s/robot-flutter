import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robot/store/app_store.dart';

class ExamModePage extends StatelessWidget {
  const ExamModePage({super.key});

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
          // --- ลบส่วน Auto-redirect (PostFrameCallback) ออกแล้ว ---
          // เพื่อให้เมื่อกลับมาหน้านี้อีกครั้ง ผู้ใช้ยังคงเห็นเมนูเลือกโหมดอยู่เสมอ

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
                  color: const Color(0xFFB15731), // accentOrange
                  isLocked: currentUser == null, // แสดงไอคอนล็อกถ้ายังไม่ Login
                  onTap: () async {
                    if (currentUser == null) {
                      // ถ้ายังไม่ Login ให้ไป Login ก่อน
                      await loginWithGoogle(context);
                      
                      // หลังจาก Login เสร็จ (ถ้าสำเร็จ) ให้พาเข้าหน้า Testing ทันทีในครั้งแรกนี้
                      if (currentUser != null) {
                        getTesting(mode: 'competition');
                        if (context.mounted) context.pushReplacement('/testing');
                      }
                    } else {
                      // ถ้า Login อยู่แล้ว แค่ดึงข้อมูลแล้วไปหน้าสอบ
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
                  color: const Color(0xFF6A806A), // primaryGreen
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
            width: 1
          ),
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
              child: Icon(
                isLocked ? Icons.lock_outline : icon, 
                color: isLocked ? Colors.grey : color, 
                size: 30
              ),
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
                      color: Colors.grey.shade600
                    ),
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