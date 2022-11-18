import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  const FormButton({super.key, required this.width, required this.text});
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () => 10,
        style: ElevatedButton.styleFrom(
            minimumSize: Size(width, 47),
            backgroundColor: const Color(0xFF28AFB0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      )
    ]);
  }
}
