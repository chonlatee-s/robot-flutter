import 'package:flutter/material.dart';
import 'package:robot/routes.dart';

void main() {
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
