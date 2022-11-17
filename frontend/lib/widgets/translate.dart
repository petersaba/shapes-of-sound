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
      children: [Expanded(child: Image.asset(
          'assets/images/letter_a.png',
          width: double.infinity,
          fit: BoxFit.contain,
          ),)
        
      ],
    );
  }
}