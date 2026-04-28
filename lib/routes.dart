import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robot/history_page.dart';
import 'package:robot/pages/about_us_page.dart';
import 'package:robot/pages/home_page.dart';
import 'package:robot/pages/landing_page.dart';
import 'package:robot/pages/pay_page.dart';
import 'package:robot/pages/testing_page.dart';
import 'package:robot/pages/exam_mode_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) => const LandingPage(),
  ),
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) => const HomePage(),
  ),
  GoRoute(
    path: '/aboutUs',
    builder: (BuildContext context, GoRouterState state) => const AboutUsPage(),
  ),
  GoRoute(
    path: '/pay',
    builder: (BuildContext context, GoRouterState state) => const PayPage(),
    ),
  GoRoute(
    path: '/exam-mode',
    builder: (BuildContext context, GoRouterState state) => const ExamModePage(),
  ),
  GoRoute(
    path: '/testing',
    builder: (BuildContext context, GoRouterState state) => const TestingPage(),
  ),
  GoRoute(
    path: '/history',
    builder: (context, state) => const HistoryPage(),
  ),
]);