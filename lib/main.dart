import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'page/dashboard_page.dart';
import 'routes/app_pages.dart';
import 'routes/route_names.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
      getPages: AppPages.pages, // Routing aplikasi
      initialRoute: RouteNames.homeScreen, // Rute awal aplikasi
    ),
  );
}
