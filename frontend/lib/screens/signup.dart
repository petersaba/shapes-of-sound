import 'package:flutter/material.dart';
import 'package:frontend/widgets/dropdown.dart';
import 'package:frontend/widgets/form_button.dart';
import 'package:frontend/widgets/switch_pages_button.dart';
import 'package:frontend/widgets/text_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: double.infinity,
            color: const Color(0xFFF3F5F8),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('assets/images/no-profile.png', width: 200, height: 200,),
                ),
                const SizedBox(
                  height: 20,
                ),
                const FormButton(width: 110, text: 'Add image'),
                const SizedBox(
                  height: 20,
                ),
                const TextInput(text: 'Email',
                  regex: '.{.{3,}@.{3,}\..{2,}}',),
                const SizedBox(
                  height: 20,
                ),
                const TextInput(text: 'Full name',
                  regex: '.{3,}',),
                const SizedBox(
                  height: 20,
                ),
                const TextInput(text: 'Password',
                  regex: '.{12,}',),
                const SizedBox(
                  height: 20,
                ),
                const TextInput(
                  text: 'Confirm Password',
                  regex: '.{12,}',
                ),
                const SizedBox(
                  height: 20,
                ),
                const DropDown(text: 'Gender'),
                const SizedBox(
                  height: 20,
                ),
                const FormButton(width: 330, text: 'Sign Up', route: '/home',),
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
            )));
  }
}
