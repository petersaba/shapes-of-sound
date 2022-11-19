import 'package:flutter/cupertino.dart';

class UserInfo extends ChangeNotifier {
  String _imagePath = 'assets/images/no-profile.png';

  String get imagePath => _imagePath;

  void setPath(String path) {
    _imagePath = path;
    notifyListeners();
  }
}
