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
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF355085))),
                  height: 40,
                  child: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text('Female'),
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
