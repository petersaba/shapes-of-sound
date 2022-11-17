import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomepageMainSection extends StatefulWidget {
  const HomepageMainSection({super.key});

  @override
  State<HomepageMainSection> createState() => _HomepageMainSectionState();
}

class _HomepageMainSectionState extends State<HomepageMainSection> {
  bool _isPermanent =
      false; // if the microphone permission is permanently denied

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            'assets/images/letter_a.png',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        Container(
          height: 60,
          color: const Color(0x4D808080),
          child: Row(
            children: [
              const Expanded(
                  child: TextField(
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type here',
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: ElevatedButton(
                  onPressed: _record,
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFF28AFB0),
                      minimumSize: const Size(40, 40)),
                  child: const Icon(Icons.mic),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _record() async {
    final permission = await Permission.microphone.request();
    print(permission);
    if (permission == PermissionStatus.granted) {
      _isPermanent = false;
    }
  }
}
