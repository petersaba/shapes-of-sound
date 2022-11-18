import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                // Image.asset('assets/images/no-profile.png', width: 200, height: 200,)
              ],
            )));
  }
}
