import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 330,
        child: ElevatedButton(
            onPressed: (() => Navigator.pushNamed(context, route)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Text('Sign Up',
                    style: TextStyle(
                        color: Color(0xFF28AFB0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            )));
  }
}
