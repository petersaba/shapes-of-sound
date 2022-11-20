import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.width,
    required this.text,
    required this.function,
    this.formKey,
  });
  final Function function;
  final GlobalKey<FormState>? formKey;
  final double width;
  final String text;


  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: (() => function(formKey)),
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
