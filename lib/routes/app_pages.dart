import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart'
    as get_transition;
import '../page/capture_page.dart';
import '../page/dashboard_page.dart';
import '../page/live_camera_page.dart';
import 'route_names.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RouteNames.homeScreen,
      page: () => DashboardPage(),
      curve: Curves.easeInOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RouteNames.livePreview,
      page: () => LiveCameraPage(),
      curve: Curves.easeInOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RouteNames.capturePage,
      page: () => CapturePage(),
      curve: Curves.easeInOut,
      transition: Transition.rightToLeft,
    ),
  ];
}
