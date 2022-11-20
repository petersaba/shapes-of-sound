import 'package:flutter/material.dart';
import 'package:frontend/utilities.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.width,
    required this.text,
    required this.function,
    this.attributeMap,
    this.route,
  });
  final Function function;
  final Map? attributeMap;
  final String? route;
  final double width;
  final String text;

  void _navigate(BuildContext context) {
    // if (route != null) {
    //   Navigator.pushReplacementNamed(context, route!);
    // }

    // postRequest('login');
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () => _navigate(context),
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
