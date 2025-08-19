import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/apiendpoint.dart';

// Asumsikan ApiEndpoints.dart sudah dimodifikasi seperti di atas

class ApiSettingsPage extends StatefulWidget {
  @override
  _ApiSettingsPageState createState() => _ApiSettingsPageState();
}

class _ApiSettingsPageState extends State<ApiSettingsPage> {
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
  }

  // Memuat URL dari SharedPreferences saat halaman dibuka
  _loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('baseUrl') ?? 'http://127.0.0.1:5000';
    _urlController.text = url;
    ApiEndpoints.setBaseUrl(url); // Set base URL di class ApiEndpoints
  }

  // Menyimpan URL ke SharedPreferences
  _saveBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', _urlController.text);
    ApiEndpoints.setBaseUrl(_urlController.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Base URL berhasil diubah!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Base URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveBaseUrl, child: Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
