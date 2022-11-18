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
              children: const [
                Center(
                    child: Text(
                  'Sign Up',
                  style: TextStyle(fontFamily: 'AlfaSlabOne', fontSize: 45),
                )),
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 170,
                backgroundImage: AssetImage('assets/images/no-profile.png'),
                ),
                SizedBox(height: 20,),
                FormButton(width: 110, text: 'Add image'),
                SizedBox(height: 20,),
                TextInput(text: 'Email'),
                SizedBox(height: 20,),
                TextInput(text: 'Full name'),
                SizedBox(height: 20,),
                TextInput(text: 'Password'),
                SizedBox(height: 20,),
                TextInput(text: 'Confirm Password'),
                SizedBox(height: 20,),
                DropDown(text: 'Gender'),
                SizedBox(height: 20,),
                FormButton(width: 330, text: 'Sign Up'),
                SizedBox(height: 20,),
                SwitchButton(route: '/login',),
                SizedBox(height: 20,)
              ],
            )));
  }
}
