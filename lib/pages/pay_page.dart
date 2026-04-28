import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ต้อง import ตัวนี้เพื่อใช้ Clipboard

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  static const Color primaryGreen = Color(0xFF6A806A);
  static const Color darkText = Color(0xFF2D2F31);
  static const Color accentOrange = Color(0xFFB15731);
  static const Color lightBackground = Color(0xFFF8F9F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'เลี้ยงชานมไข่มุก',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: primaryGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/img/qr.png',
                            width: 200,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'พร้อมเพย์ (PromptPay)',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        
                        // --- ส่วนที่ปรับปรุง: เพิ่มฟังก์ชัน Copy ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 40), // เพื่อให้เบอร์อยู่กลางพอดี
                            Text(
                              '0827818941',
                              style: const TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: darkText,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(text: "0827818941"));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('คัดลอกเบอร์โทรศัพท์แล้ว', style: TextStyle(fontFamily: 'Kanit')),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: primaryGreen,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy_rounded, color: primaryGreen, size: 20),
                              tooltip: 'คัดลอกเบอร์',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  _buildDetailRow('ชื่อบัญชี', 'ชลธี  สินสาตร์'),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Color(0xFFE0E0E0), thickness: 0.8),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryGreen.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: primaryGreen, size: 20),
                            const SizedBox(width: 10),
                            const Text(
                              'ข้อความถึงคู่หู',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'ระลึกเสมอว่า การสอบครั้งนี้จะเป็นการเหนื่อยครั้งสุดท้ายของเธอแล้วจริง ๆ จงเชื่อมั่นในตัวเองนะ เธอทำได้ และเธอทำได้! ไว้มีโอกาสมาชนแก้วชานมไข่มุกเพื่อฉลองความสำเร็จไปด้วยกันนะ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: darkText,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryGreen, Color(0xFF4F634F)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'ขอบคุณที่ดูแลกันนะ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'เพราะร่างกายขาดชานมไข่มุกไม่ได้',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.9),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Kanit', fontSize: 15, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontFamily: 'Kanit', fontSize: 15, fontWeight: FontWeight.w500, color: accentOrange),
          ),
        ],
      ),
    );
  }
}