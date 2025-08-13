// controllers/dashboard_controller.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class DashboardController extends GetxController {
  RxString streamUrl = "".obs;
  RxBool isLoading = false.obs;
  VlcPlayerController? liveCameraController;

  void setLiveCameraController(VlcPlayerController controller) {
    liveCameraController = controller;
  }

  RxList<Map<String, dynamic>> recentActivities = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> systemStats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    setupSystemStats();
  }

  void setStreamUrl(String url) {
    streamUrl.value = url;
  }

  Future<void> captureImageFromStream() async {
    if (liveCameraController == null) return;

    final snapshot = await liveCameraController!.takeSnapshot();
    if (snapshot != null) {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/snapshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(snapshot);
      print("Snapshot saved to $filePath");
    }
  }

  void loadDashboardData() {
    isLoading.value = true;

    // Simulasi data aktivitas terbaru
    recentActivities.value = [
      {
        'title': 'Fighting Detected',
        'subtitle': 'Camera 1',
        'time': '2 minutes ago',
        'icon': Icons.videocam,
        'type': 'alert',
      },
    ];

    Future.delayed(Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }

  void setupSystemStats() {
    systemStats.value = [
      {
        'title': 'Active Cameras',
        'value': '1/1',
        'icon': Icons.videocam,
        'color': Colors.blue,
      },
      {
        'title': 'Fighting data',
        'value': '20',
        'icon': Icons.data_usage,
        'color': Colors.yellow,
      },
    ];
  }

  void refreshData() {
    loadDashboardData();
    Get.snackbar(
      'Refreshed',
      'Dashboard data updated',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
}
