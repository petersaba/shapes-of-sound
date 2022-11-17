import 'package:flutter/material.dart';

class HomepageMainSection extends StatefulWidget {
  const HomepageMainSection({super.key});

  @override
  State<HomepageMainSection> createState() => _HomepageMainSectionState();
}

class _HomepageMainSectionState extends State<HomepageMainSection> {
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
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () => 10, child: const Icon(Icons.mic)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
