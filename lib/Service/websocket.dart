import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  Stream get stream => _channel.stream;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void sendMessage(dynamic data) {
    _channel.sink.add(jsonEncode(data));
  }

  void dispose() {
    _channel.sink.close();
  }
}
