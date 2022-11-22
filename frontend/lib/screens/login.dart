import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';
import 'package:frontend/widgets/form_button.dart';
import 'package:frontend/widgets/switch_pages_button.dart';
import 'package:frontend/widgets/text_input.dart';
import 'package:frontend/providers/login_info.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _wrongCredentials = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFFF3F5F8),
            child: Center(
                child: SizedBox(
                    height: double.infinity,
                    child: Form(
                        key: _formKey,
                        child: Center(
                            child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 260,
                                  height: 260,
                                ),
                              ] +
                              [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                    child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontFamily: 'AlfaSlabOne', fontSize: 45),
                                )),
                                _wrongCredentials == true
                                    ? const Center(
                                        child: Text(
                                        'Invalid credentials',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 16),
                                      ))
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 20,
                                ),
                              ] +
                              [
                                TextInput(
                                  text: 'Email',
                                  regex: RegExp(r'.{3,}@.{3,}\..{2,}'),
                                  attribute: 'email',
                                  onSave: saveInput,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextInput(
                                  text: 'Password',
                                  regex: RegExp(r'.{8,}'),
                                  isPassword: true,
                                  attribute: 'password',
                                  onSave: saveInput,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ] +
                              [
                                FormButton(
                                  width: 330,
                                  text: 'Login',
                                  function: login,
                                  formKey: _formKey,
                                ),
                              ] +
                              const [
                                SizedBox(
                                  height: 20,
                                ),
                                SwitchButton(
                                  route: '/signup',
                                )
                              ],
                        )))))));
  }

  void saveInput(String attribute, String value) {
    context.read<LoginInfo>().setAttribute(attribute, value);
  }

  void login(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    final model = Provider.of<LoginInfo>(context, listen: false);
    final email = model.getAttribute('email');
    final password = model.getAttribute('password');

    Map requestBody = {'email': email, 'password': password};
    Response response = await postRequest('login', requestBody);
    if (response.statusCode != 200) {
      setState(() {
        _wrongCredentials = true;
      });
      return;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map responseData = jsonDecode(response.body);
    sharedPreferences.setString('token', responseData['access_token']);
    String fullName = responseData['user']['full_name'];
    String imagePath = responseData['user']['image_path'];

    if (!mounted) return;
    fillUserInfo(context, fullName, imagePath);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
