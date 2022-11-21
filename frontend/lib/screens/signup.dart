import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/providers/signup_info.dart';
import 'package:frontend/widgets/dropdown.dart';
import 'package:frontend/widgets/form_button.dart';
import 'package:frontend/widgets/switch_pages_button.dart';
import 'package:frontend/widgets/text_input.dart';
import 'package:provider/provider.dart';
import 'package:frontend/utilities.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:frontend/providers/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _wrongCredentials = false;
  String _message = 'Invalid Credentials';
  File? _chosenImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: double.infinity,
            color: const Color(0xFFF3F5F8),
            child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Center(
                        child: Text(
                      'Sign Up',
                      style: TextStyle(fontFamily: 'AlfaSlabOne', fontSize: 45),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _chosenImage != null
                                ? Image.file(
                                    _chosenImage!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/no-profile.png',
                                    width: 200,
                                    height: 200,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
                    _wrongCredentials == true
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(),
                    FormButton(
                      width: 110,
                      text: 'Add image',
                      function: () => saveImage(context),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextInput(
                      text: 'Email',
                      regex: RegExp(r'.{3,}@.{3,}\..{2,}'),
                      attribute: 'email',
                      onSave: _saveInput,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextInput(
                      text: 'Full name',
                      regex: RegExp(r'.{3,}'),
                      attribute: 'fullName',
                      onSave: _saveInput,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextInput(
                      isPassword: true,
                      text: 'Password',
                      regex: RegExp(r'.{12,}'),
                      attribute: 'password',
                      onSave: _saveInput,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextInput(
                      isPassword: true,
                      text: 'Confirm Password',
                      regex: RegExp(r'.{12,}'),
                      attribute: 'confPassword',
                      onSave: _saveInput,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropDown(
                      text: 'Gender',
                      attribute: 'gender',
                      onChange: _saveInput,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormButton(
                      width: 330,
                      text: 'Sign Up',
                      function: _signUp,
                      formKey: _formKey,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SwitchButton(
                      route: '/login',
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ))));
  }

  void _saveInput(String attribute, String value) {
    context.read<SignUpInfo>().setAttribute(attribute, value);
  }

  void _signUp(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    SignUpInfo model = Provider.of<SignUpInfo>(context, listen: false);
    final email = model.getAttribute('email');
    final fullName = model.getAttribute('fullName');
    final password = model.getAttribute('password');
    final confPassword = model.getAttribute('confPassword');
    final gender = model.getAttribute('gender');
    final base64Image = model.getAttribute('image');

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

    UserInfo infoModel = Provider.of<UserInfo>(context, listen: false);

    Map bodyData = {
      'email': email,
      'full_name': fullName,
      'password': password,
      'gender': gender,
    };
    if (base64Image != null) {
      bodyData['base64_image'] = base64Image;
    }

    Response response = await postRequest('signup', bodyData);
    if (response.statusCode != 200) {
      setState(() {
        _wrongCredentials = true;
        _message = jsonDecode(response.body)['message'];
      });
      return;
    }

    infoModel.setAttribute('email', email!);
    infoModel.setAttribute('password', password!);

    bodyData = {'email': email, 'password': password};
    response = await postRequest('login', bodyData);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final responseBody = jsonDecode(response.body);
    sharedPreferences.setString('token', responseBody['access_token']);

    if (mounted) {
      fillUserInfo(context, fullName!, responseBody['user']['image_path']);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void saveImage(BuildContext context) async {
    File image = await selectImage();
    setState(() {
      _chosenImage = image;
    });

    final base64Image = await imageToBase64(image);
    if (mounted) {
      context.read<SignUpInfo>().setAttribute('image', base64Image);
    }
  }
}
