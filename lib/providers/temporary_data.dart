import 'package:flutter/material.dart';

// Holds temporary data
// Could have used other way
class TemporaryData with ChangeNotifier {
  String? wardNo = '';
  String? category = '';
  // String title = '';
  // String description = '';

  void setWardNo(String? getWardNo) {
    wardNo = getWardNo;
    notifyListeners();
  }

  void setCategory(String getCategory) {
    category = getCategory;
    notifyListeners();
  }
}
