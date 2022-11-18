import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({super.key, required this.text, required this.regex});
  final String regex;
  final String text;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  String validate(String? value) {

    
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 330,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                  validator: ((value) => validate(value)),
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      fillColor: const Color(0xFFFFFFFF),
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF355085)),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF355085)),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
