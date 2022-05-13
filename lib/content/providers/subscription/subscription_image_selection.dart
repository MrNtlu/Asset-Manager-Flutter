import 'package:flutter/material.dart';

class SubscriptionImageSelection with ChangeNotifier {
  String? selectedImage;

  void imageSelected(String image) {
    if (selectedImage != image) {
      selectedImage = image;
      notifyListeners();
    }
  }

  void onDispose() {
    selectedImage = null;
  }
}
