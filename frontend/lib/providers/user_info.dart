import 'package:flutter/cupertino.dart';

class UserInfo extends ChangeNotifier {
  String _imagePath = 'assets/images/no-profile.png';
  String? _email;
  String? _password;

  String? getAttribute(String attribute) {
    switch (attribute) {
      case 'imagePath':
        return _imagePath;

      case 'email':
        return _email;

      case 'password':
        return _password;
    }

    return null;
  }

  void setAttribute(String attribute, String value) {
    switch (attribute) {
      case 'imagePath':
        _imagePath = value;
        break;

      case 'email':
        _email = value;
        break;

      case 'password':
        _password = value;
        break;
    }
    notifyListeners();
  }
}
