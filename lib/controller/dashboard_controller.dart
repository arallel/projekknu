// controllers/dashboard_controller.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:projekknu/routes/apiendpoint.dart';

class DashboardController extends GetxController {
  RxString streamUrl = "".obs;
  RxBool isLoading = false.obs;
  VlcPlayerController? liveCameraController;

  void setLiveCameraController(VlcPlayerController controller) {
    liveCameraController = controller;
  }

  final recentActivities = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> systemStats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
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

  Future<void> fetchData() async {
    try {
      isLoading(true);

      // Ganti dengan endpoint Flask kamu
      final response = await http.get(Uri.parse(ApiEndpoints.getrecentalert));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final alerts = data['alerts'] as List;

        recentActivities.clear();
        for (var item in alerts) {
          recentActivities.add({
            'title': 'Fight Detected',
            'subtitle':
                'Confidence: ${(item['confidence'] * 100).toStringAsFixed(1)}%',
            'time': item['timestamp_readable'],
            'type': 'alert',
            'icon': Icons.security,
            'image_url': item['image_url'],
          });
        }
      }
    } catch (e) {
      print("Error fetching alerts: $e");
    } finally {
      isLoading(false);
    }
  }

  void loadDashboardData() {
    isLoading.value = true;

    fetchData();
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

  Future<void> refreshData() async {
    loadDashboardData();
    Get.snackbar(
      'Refreshed',
      'Dashboard data updated',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
}
