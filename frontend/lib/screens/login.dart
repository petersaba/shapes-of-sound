import 'package:flutter/material.dart';
import 'package:frontend/widgets/form_button.dart';
import 'package:frontend/widgets/switch_pages_button.dart';
import 'package:frontend/widgets/text_input.dart';
import 'package:frontend/providers/login_info.dart';
import 'package:provider/provider.dart';

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
                              ] +
                              [
                                TextInput(
                                  text: 'Email',
                                  regex: '.{3,}@.{3,}\..{2,}',
                                  attribute: 'email',
                                  onSave: saveInput,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextInput(
                                  text: 'Password',
                                  regex: '.{12,}',
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
                                  route: '/home',
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

  void login(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    final model = Provider.of<LoginInfo>(context, listen: false);
    final email = model.getAttribute('email');
    final password = model.getAttribute('password');

    debugPrint('email: ${email!} password: ${password!}');
  }
}
