import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:projekknu/routes/route_names.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveCameraController extends GetxController {
  final String socketUrl;
  LiveCameraController(this.socketUrl);

  late WebSocketChannel _channel;
  var imageBytes = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(RouteNames.livePreview));

    _channel.stream.listen(
      (message) {
        try {
          // Asumsikan server mengirim base64 string gambar
          final decodedBytes = base64Decode(message);
          imageBytes.value = decodedBytes;
        } catch (e) {
          log("Error decoding image: $e");
        }
      },
      onError: (err) {
        log("WebSocket error: $err");
      },
      onDone: () {
        log("WebSocket connection closed");
      },
    );
  }

  @override
  void onClose() {
    _channel.sink.close();
    super.onClose();
  }
}
