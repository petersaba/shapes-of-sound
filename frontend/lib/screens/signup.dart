import 'package:flutter/material.dart';
import 'package:frontend/widgets/form_button.dart';

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
                Image.asset('assets/images/no-profile.png', width: 200, height: 200,),
                const SizedBox(height: 20,),
                const FormButton(width: 110, text: 'Add image')
              ],
            )));
  }
}
