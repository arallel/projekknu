import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mjpeg_view/mjpeg_view.dart';
import 'package:projekknu/routes/apiendpoint.dart';

class LiveCameraPage extends StatefulWidget {
  const LiveCameraPage({super.key});

  @override
  State<LiveCameraPage> createState() => _LiveCameraPageState();
}

class _LiveCameraPageState extends State<LiveCameraPage> {
  int _reloadKey = 0; // untuk memicu reload MjpegView
  Timer? _retryTimer;

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _reloadKey++; // memicu rebuild
      });
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("Live Camera"), elevation: 2),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 500),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black26,
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  // Gunakan key berbeda untuk refresh
                  MjpegView(
                    key: ValueKey(_reloadKey),
                    uri: ApiEndpoints.livepreview,
                    timeout: const Duration(seconds: 60),
                    loadingWidget:
                        (context) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        ),
                    errorWidget: (context) {
                      // Jadwalkan refresh otomatis
                      _scheduleRetry();
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Gagal memuat stream\nMengulang dalam 5 detik...",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
