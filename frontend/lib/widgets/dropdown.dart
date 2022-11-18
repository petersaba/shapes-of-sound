import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key, required this.text});
  final String text;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
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
                  child: DropdownButton(
                    items: [
                      DropdownMenuItem(child: Text('Male'), value: 'male'),
                      DropdownMenuItem(
                        child: Text('Female'),
                        value: 'female',
                      )
                    ],
                    onChanged: ((value) => 10),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
