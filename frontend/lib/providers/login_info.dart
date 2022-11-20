import 'package:flutter/cupertino.dart';

class LoginInfo with ChangeNotifier {
  String? _email;
  String? _password;

  String? getAttribute(String attribute) {
    switch (attribute) {
      case 'email':
        return _email;

      case 'password':
        return _password;
    }

    return null;
  }

  void setAttribute(String attribute, String value) {
    switch (attribute) {
      case 'email':
        _email = value;
        return;

      case 'password':
        _password = value;
        return;
    }
  }
}
