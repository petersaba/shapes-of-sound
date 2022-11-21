import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown(
      {super.key,
      required this.text,
      required this.attribute,
      required this.onChange});
  final String text;
  final String attribute;
  final Function onChange;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _selectedItem = 'male';

  @override
  void initState() {
    widget.onChange(widget.attribute, _selectedItem);
    super.initState();
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
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF355085))),
                  height: 40,
                  child: DropdownButton(
                    value: _selectedItem,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'male',
                        child: Text('  Male'),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text('  Female'),
                      )
                    ],
                    onChanged: ((value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                      widget.onChange(widget.attribute, value);
                    }),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
