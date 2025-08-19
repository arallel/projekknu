class ApiEndpoints {
  // Gunakan late agar bisa diinisialisasi nanti
  static late String _baseUrl;

  // Setter untuk mengubah base URL
  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  // Getter untuk URL yang sudah dimodifikasi
  static String get detect => '$_baseUrl/detect';
  static String get livepreview => '$_baseUrl/snapshot';
  static String get getrecentalert => '$_baseUrl/getrecentalerts';
}
