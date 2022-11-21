import 'package:flutter/cupertino.dart';

class SignUpInfo with ChangeNotifier {
  String? _email;
  String? _fullName;
  String? _password;
  String? _confPassword;
  String? _gender;
  String? _base64Image;

  String? getAttribute(String attribute) {
    switch (attribute) {
      case 'email':
        return _email;

      case 'fullName':
        return _fullName;

      case 'password':
        return _password;

      case 'confPassword':
        return _confPassword;

      case 'gender':
        return _gender;

      case 'image':
        return _base64Image;
    }

    return null;
  }

  void setAttribute(String attribute, String value) {
    switch (attribute) {
      case 'email':
        _email = value;
        return;

      case 'fullName':
        _fullName = value;
        return;

      case 'password':
        _password = value;
        return;

      case 'confPassword':
        _confPassword = value;
        return;

      case 'gender':
        _gender = value;
        return;

      case 'image':
        _base64Image = value;
        return;
    }
  }
}
