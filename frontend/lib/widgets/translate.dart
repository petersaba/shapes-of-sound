import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:frontend/utilities.dart';

class HomepageMainSection extends StatefulWidget {
  const HomepageMainSection({super.key});
  final imagesFolder = './assets/images/';

  @override
  State<HomepageMainSection> createState() => _HomepageMainSectionState();
}

class _HomepageMainSectionState extends State<HomepageMainSection> {
  final _recorder = FlutterSoundRecorder();
  final _filename = 'recording.wav';
  Icon _recordButtonIcon = const Icon(Icons.mic);
  String _currentImage = '';
  bool _imageExists = true;
  final _inputController = TextEditingController();
  bool _enableTextInput = true;
  bool _disableRecording = false;

  @override
  void initState() {
    _currentImage = '${widget.imagesFolder}logo.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: _imageExists == true
                ? Image.asset(
                    _currentImage,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : const SizedBox()),
        Container(
          height: 60,
          color: const Color(0x4D808080),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                enabled: _enableTextInput,
                controller: _inputController,
                onChanged: _changeRecordIcon,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type here',
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: ElevatedButton(
                  onPressed: _disableRecording == false
                      ? _inputController.text != ''
                          ? (() => _showCharacterImages(_inputController.text))
                          : _startOrStopRecord
                      : () => 10,
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFF28AFB0),
                      minimumSize: const Size(40, 40)),
                  child: _disableRecording == true
                      ? Image.asset(
                          'assets/images/loading.gif',
                          width: 25,
                          height: 25,
                        )
                      : _recordButtonIcon,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _record(String tempPath) async {
    final permission = await Permission.microphone.request();
    if (permission == PermissionStatus.granted) {
      await _startRecording(tempPath);
      Future.delayed(const Duration(seconds: 10),
          (() async => await _stopRecording(tempPath)));

      // on IOS there is no do not allow once, hence do not allow is permanent
    } else if (Platform.isIOS ||
        permission == PermissionStatus.permanentlyDenied) {}
  }

  Future<void> _startRecording(String tempPath) async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
    await _recorder.startRecorder(
        toFile: '$tempPath/$_filename', sampleRate: 22050);
    setState(() {
      _recordButtonIcon = const Icon(Icons.stop);
      _enableTextInput = false;
    });
  }

  Future<void> _stopRecording(String tempPath) async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();
      setState(() {
        _disableRecording = true;
      });

      String transcription = await _getAudioTranscription(tempPath);
      _inputController.text = transcription;
      _enableTextInput = true;
      setState(() {
        _recordButtonIcon = const Icon(Icons.send);
        _disableRecording = false;
      });
      _showCharacterImages(transcription);
    }
  }

  Future<String> _getTempPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  // the transcribe api takes audio in base64 but it is currently not used
  // Future<String> _getBase64String(String tempPath) async {
  //   final file = File('$tempPath/$_filename');
  //   final fileContent = await file.readAsBytes();
  //   return base64Encode(fileContent);
  // }

  void _startOrStopRecord() async {
    final tempPath = await _getTempPath();
    if (_recorder.isRecording) {
      await _stopRecording(tempPath);
    } else {
      await _record(tempPath);
    }
  }

  void _changeRecordIcon(String text) {
    setState(() {
      if (text != '') {
        _recordButtonIcon = const Icon(Icons.send);
      } else {
        _recordButtonIcon = const Icon(Icons.mic);
      }
    });
  }

  void _showCharacterImages(String sentence) async {
    for (var code in sentence.runes) {
      await Future.delayed(const Duration(milliseconds: 500), (() {
        setState(() {
          String char = String.fromCharCode(code);
          char = char.toLowerCase();
          final imageExists = RegExp(r'[a-z]').hasMatch(char);
          setState(() {
            _imageExists = imageExists;
          });

          if (imageExists) {
            _currentImage = '${widget.imagesFolder}letter_$char.png';
          }
        });
      }));
    }
    await Future.delayed(const Duration(milliseconds: 500), (() {
      setState(() {
        _imageExists = true;
        _currentImage = '${widget.imagesFolder}logo.png';
      });
    }));
  }

  Future<String> _getAudioTranscription(String tempPath) async {
    final file = File('$tempPath/$_filename');
    final fileContent = await file.readAsBytes();
    Map response = await uploadToAssemblyAi(fileContent);

    // the audio becomes stored in the upload url path
    Map bodyData = {'audio_url': response['upload_url']};

    response = await transcribeAssemblyAi(bodyData);
    String transcriptionId = response['id'];
    response = await getTranscription(transcriptionId);

    return response['text'];
  }
}
