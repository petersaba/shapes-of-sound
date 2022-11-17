import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F5F8),
      child: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => 10,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minimumSize: const Size(100, 47)),
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        Image.asset(
          'assets/images/no-profile.png',
          width: 226,
          height: 226,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ElevatedButton(
            onPressed: () => 10,
            style: ElevatedButton.styleFrom(minimumSize: const Size(110, 47)),
            child: const Text('Edit image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
          )
        ]),
      ]),
    );
  }
}
