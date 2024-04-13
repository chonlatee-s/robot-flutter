import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robot/pages/job_page.dart';
import 'package:robot/pages/about_us_page.dart';
import 'package:robot/pages/agenda_page.dart';
import 'package:robot/pages/guideline_page.dart';
import 'package:robot/pages/home_page.dart';
import 'package:robot/pages/landing_page.dart';
import 'package:robot/pages/pay_page.dart';
import 'package:robot/pages/predict_page.dart';
import 'package:robot/pages/testing_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const LandingPage();
    },
  ),
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: '/aboutUs',
    builder: (BuildContext context, GoRouterState state) {
      return const AboutUsPage();
    },
  ),
  GoRoute(
    path: '/pay',
    builder: (BuildContext context, GoRouterState state) {
      return const PayPage();
    },
  ),
  GoRoute(
    path: '/agenda',
    builder: (BuildContext context, GoRouterState state) {
      return const AgendaPage();
    },
  ),
  GoRoute(
    path: '/guideline',
    builder: (BuildContext context, GoRouterState state) {
      return const GuidelinePage();
    },
  ),
  GoRoute(
    path: '/testing',
    builder: (BuildContext context, GoRouterState state) {
      return const TestingPage();
    },
  ),
  GoRoute(
    path: '/job',
    builder: (BuildContext context, GoRouterState state) {
      return const JobPage();
    },
  ),
  GoRoute(
    path: '/predict',
    builder: (BuildContext context, GoRouterState state) {
      return const PredictPage();
    },
  ),
]);
