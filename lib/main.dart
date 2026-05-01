import 'package:flutter/material.dart';
import 'package:robot/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // 1. ต้องมีบรรทัดนี้เสมอ
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. วิธีแก้: เรียก initialize โดยไม่ต้อง await 
  // หรือใช้ .then เพื่อให้แอปทำงานต่อไปได้ทันที (Non-blocking)
  MobileAds.instance.initialize().then((status) {
    debugPrint('AdMob Initialized: ${status.adapterStatuses}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
