// pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mjpeg_view/mjpeg_view.dart';
import 'package:projekknu/routes/apiendpoint.dart';
import '../controller/dashboard_controller.dart';
import '../routes/route_names.dart';
import 'package:camera/camera.dart';
import '../widget/LiveCameraWidget.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: () async => controller.refreshData(),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 20),
                        _buildQuickStats(),
                        SizedBox(height: 20),
                        _buildLivePreview(),
                        SizedBox(height: 20),
                        _buildRecentActivities(),
                        SizedBox(height: 100), // Bottom padding for navigation
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'Monitor your security system',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue[700]),
            onPressed: () => controller.refreshData(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Obx(
          () => GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.systemStats.length,
            itemBuilder: (context, index) {
              final stat = controller.systemStats[index];
              return _buildStatCard(stat);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(stat['icon'], color: stat['color'], size: 20),
              ),
              SizedBox(width: 8),
            ],
          ),
          SizedBox(height: 12),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: stat['title'] + " ",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                TextSpan(
                  text: stat['value'],
                  style: TextStyle(
                    fontSize: 14, // lebih besar dari title
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLivePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Live Preview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Row(
              children: [
                IconButton(
                  tooltip: "Capture Snapshot",
                  icon: Icon(Icons.camera_alt, color: Colors.blue[700]),
                  onPressed: () async {
                    Get.toNamed(RouteNames.capturePage);
                  },
                ),
                TextButton.icon(
                  onPressed: () => Get.toNamed(RouteNames.livePreview),
                  icon: Icon(Icons.open_in_full, size: 18),
                  label: Text('Live Preview'),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
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
                    // Live stream
                    // MjpegView(
                    //   uri: ApiEndpoints.livepreview,
                    //   timeout: const Duration(seconds: 60),
                    //   loadingWidget:
                    //       (context) => const Center(
                    //         child: CircularProgressIndicator(
                    //           color: Colors.blueAccent,
                    //         ),
                    //       ),
                    //   errorWidget:
                    //       (context) => const Center(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Icon(
                    //               Icons.error_outline,
                    //               color: Colors.redAccent,
                    //               size: 48,
                    //             ),
                    //             SizedBox(height: 8),
                    //             Text(
                    //               "Gagal memuat stream",
                    //               style: TextStyle(color: Colors.redAccent),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    // ),
                    LiveCameraWidget(streamUrl: ""),
                    // Overlay label "LIVE"
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
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Obx(() {
      // Jika tidak ada data, jangan tampilkan apa-apa
      if (controller.recentActivities.isEmpty) {
        return SizedBox.shrink(); // Tidak ada elemen yang ditampilkan
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Report',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.recentActivities.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              final activity = controller.recentActivities[index];
              return _buildActivityCard(activity);
            },
          ),
        ],
      );
    });
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              activity['image_url'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red, size: 24),
                  ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  activity['subtitle'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      activity['time'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
        ],
      ),
    );
  }
}
