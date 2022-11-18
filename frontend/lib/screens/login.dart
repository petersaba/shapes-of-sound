import 'package:flutter/material.dart';
import 'package:frontend/widgets/form_button.dart';
import 'package:frontend/widgets/switch_pages_button.dart';
import 'package:frontend/widgets/text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                              const [
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                    child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontFamily: 'AlfaSlabOne', fontSize: 45),
                                )),
                                SizedBox(
                                  height: 20,
                                ),
                                TextInput(
                                  text: 'Email',
                                  regex: '.{3,}@.{3,}\..{2,}',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextInput(
                                  text: 'Password',
                                  regex: '.{12,}',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FormButton(width: 330, text: 'Login', route: '/home',),
                                SizedBox(
                                  height: 20,
                                ),
                                SwitchButton(
                                  route: '/signup',
                                )
                              ],
                        )))))));
  }
}
