// widgets/live_camera_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveCameraWidget extends StatelessWidget {
  final String streamUrl;
  final double? height;
  final bool showControls;

  const LiveCameraWidget({
    Key? key,
    required this.streamUrl,
    this.height,
    this.showControls = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Placeholder for camera stream
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam, size: 50, color: Colors.white70),
                  SizedBox(height: 8),
                  Text(
                    'Live Stream',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    streamUrl,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Connection status indicator
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls overlay (if enabled)
            if (showControls)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: Icons.play_arrow,
                      onPressed: () {},
                    ),
                    _buildControlButton(icon: Icons.pause, onPressed: () {}),
                    _buildControlButton(
                      icon: Icons.fiber_manual_record,
                      color: Colors.red,
                      onPressed: () {},
                    ),
                    _buildControlButton(
                      icon: Icons.fullscreen,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: color ?? Colors.white),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }
}
