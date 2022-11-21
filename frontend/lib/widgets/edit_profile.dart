import 'package:flutter/material.dart';
import 'package:frontend/providers/selected_page.dart';
import 'package:frontend/utilities.dart';
import 'package:frontend/widgets/form_button.dart';
import 'package:frontend/widgets/text_input.dart';
import 'package:frontend/providers/user_info.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _wrongCredentials = false;
  String _message = 'Invalid Credentials';

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: const Color(0xFFF3F5F8),
        child: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => 10,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        minimumSize: const Size(100, 47)),
                    child: const Text(
                      'LOGOUT',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Image.asset(
              'assets/images/no-profile.png',
              width: 226,
              height: 226,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 18,
            ),
            FormButton(
              width: 110,
              text: 'Edit image',
              function: (() => null),
            ),
            const SizedBox(
              height: 18,
            ),
            TextInput(
              text: 'Full Name:',
              regex: RegExp(r'.{3,}'),
              attribute: 'fullName',
              onSave: _saveInput,
            ),
            const SizedBox(
              height: 18,
            ),
            TextInput(
              isPassword: true,
              text: 'Password:',
              regex: RegExp(r'.{8,}'),
              attribute: 'password',
              onSave: _saveInput,
            ),
            const SizedBox(
              height: 18,
            ),
            TextInput(
              isPassword: true,
              text: 'Confirm password:',
              regex: RegExp(r'.{8,}'),
              attribute: 'confPassword',
              onSave: _saveInput,
            ),
            const SizedBox(
              height: 18,
            ),
            _wrongCredentials == true
                ? Center(
                    child: Text(
                    _message,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 18),
                  ))
                : const SizedBox(),
            FormButton(
              width: 330,
              text: 'Confrim Changes',
              function: _editProfile,
              formKey: _formKey,
            ),
          ]),
        ));
  }

  void _saveInput(String attribute, String value) async {
    context.read<UserInfo>().setAttribute(attribute, value);
  }

  void _editProfile(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    UserInfo model = Provider.of<UserInfo>(context, listen: false);
    final fullName = model.getAttribute('fullName');
    final password = model.getAttribute('password');
    final confPassword = model.getAttribute('confPassword');

    if (password != confPassword) {
      setState(() {
        _wrongCredentials = true;
        _message = 'Passwords do not match';
      });
      return;
    }
    setState(() {
      _wrongCredentials = false;
    });
    debugPrint('$fullName');

    Map bodyData = {'fullName': fullName, 'password': password};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    Response response = await postRequest('edit', bodyData, token: token);

    if (response.statusCode != 200) {
      setState(() {
        _wrongCredentials = true;
        _message = jsonDecode(response.body)['message'];
      });
      return;
    }

    if (mounted) {
      context.read<SelectedPage>().selectedPage = 0;
    }
  }
}
