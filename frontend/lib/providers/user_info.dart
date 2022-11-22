import 'package:flutter/cupertino.dart';

class UserInfo extends ChangeNotifier {
  String? _imagePath;
  String? _base64Image;
  String? _fullName;
  String? _password;
  String? _confPassword;

  String? getAttribute(String attribute) {
    switch (attribute) {
      case 'imagePath':
        return _imagePath;

      case 'base64Image':
        return _base64Image;

      case 'fullName':
        return _fullName;

      case 'password':
        return _password;

      case 'confPassword':
        return _confPassword;
    }

    return null;
  }

  void setAttribute(String attribute, String value) {
    switch (attribute) {
      case 'imagePath':
        _imagePath = value;
        break;

      case 'base64Image':
        _base64Image = value;
        break;

      case 'fullName':
        _fullName = value;
        break;

      case 'password':
        _password = value;
        break;

      case 'confPassword':
        _confPassword = value;
        break;
    }
    notifyListeners();
  }
}
