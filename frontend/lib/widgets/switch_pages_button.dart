import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (() => 10),
        child: Row(
          children: [Text("Don't have an account? "),
          Text('Sign Up')],
        ));
  }
}
