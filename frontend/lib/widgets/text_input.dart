import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {super.key,
      required this.text,
      required this.regex,
      required this.onSave,
      required this.attribute,
      this.isPassword,});
  final String attribute;
  final Function onSave;
  final RegExp regex;
  final bool? isPassword;
  final String text;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  String? _validate(String? value) {
    if (value == '') {
      return 'Field should not be empty';
    } else if (!widget.regex.hasMatch(value!)) {
      return 'Input is not valid';
    }
    return null;
  }

  void _saveInput(String value) {
    widget.onSave(widget.attribute, value);
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
                  obscureText: widget.isPassword == true ? true : false,
                  validator: ((value) => _validate(value)),
                  onSaved: (newValue) => _saveInput(newValue!),
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
