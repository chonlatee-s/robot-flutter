import 'package:flutter/material.dart';
import 'package:robot/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:robot/store/app_store.dart'; // 1. ตรวจสอบว่า import ไฟล์ store มาแล้ว

void main() async {
  // ต้องมีบรรทัดนี้เสมอเพื่อให้เรียกใช้ Plugin ต่างๆ ได้ก่อน runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. เรียกใช้ระบบจำการ Login (Auto Login)
  // ใช้ await เพื่อให้แอปดึงข้อมูล User เก่ามาใส่ currentUser ให้เสร็จก่อนเริ่มหน้าแรก
  await initUser();

  // 3. เรียก initialize AdMob (แบบ Non-blocking เหมือนเดิม)
  MobileAds.instance.initialize().then((status) {
    debugPrint('AdMob Initialized: ${status.adapterStatuses}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'นายโรบอท',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 35, 72, 45),
        ),
        useMaterial3: true,
        fontFamily: 'Kanit',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}