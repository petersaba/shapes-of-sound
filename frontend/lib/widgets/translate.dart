import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomepageMainSection extends StatefulWidget {
  const HomepageMainSection({super.key});

  @override
  State<HomepageMainSection> createState() => _HomepageMainSectionState();
}

class _HomepageMainSectionState extends State<HomepageMainSection> {
  bool _isPermanent =
      false; // if the microphone permission is permanently denied
  final _recorder = FlutterSoundRecorder();

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
      final tempPath = await _getTempPath();

      await _startRecording(tempPath);
      Future.delayed(
          const Duration(seconds: 10), (() async => await _stopRecording()));

      // on IOS there is no do not allow once, hence do not allow is permanent
    } else if (Platform.isIOS ||
        permission == PermissionStatus.permanentlyDenied) {
      _isPermanent = true;
    }
  }

  Future<void> _startRecording(String tempPath) async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
    await _recorder.startRecorder(
        toFile: '$tempPath/recording.wav', sampleRate: 22050);
  }

  Future<void> _stopRecording() async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();
    }
  }

  Future<String> _getTempPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
}
