import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CaptureController extends GetxController {
  var imageFile = Rx<File?>(null);
  final picker = ImagePicker();
  var isUploading = false.obs;

  Future<void> pickFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> pickFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> uploadImage(String uploadUrl) async {
    if (imageFile.value == null) return;

    isUploading.value = true;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.value!.path),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Image uploaded successfully");
      } else {
        Get.snackbar("Error", "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploading.value = false;
    }
  }
}
