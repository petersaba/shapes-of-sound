import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// creates material color equivalent of a color object
MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  // ignore: avoid_function_literals_in_foreach_calls
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

const String baseUrl = 'http://10.0.2.2:8000/api/';
const String imagesFolder = 'http://10.0.2.2:8000/images/';
const String audioUploadUrl = 'https://api.assemblyai.com/v2/upload';
const String audioTranscriptEndpoint =
    'https://api.assemblyai.com/v2/transcript';
Map<String, String> assemblyAuthorization = {
  'Authorization': dotenv.env['ASSEMBLYAI_TOKEN']!
};

Future getRequest(String path, {String? token}) async {
  final url = Uri.parse(baseUrl + path);

  final response = await http.get(url, headers: {
    'Authorization': token != null ? 'Bearer $token' : '',
  });

  return response;
}

Future postRequest(String path, Map body, {String? token}) async {
  final url = Uri.parse(baseUrl + path);

  final response = await http.post(url, body: body, headers: {
    'Authorization': token != null ? 'Bearer $token' : '',
  });

  return response;
}

Future<Map> postToAssemblyAi(String link, List? data) async {
  final url = Uri.parse(link);

  final response =
      await http.post(url, body: data, headers: assemblyAuthorization);

  return jsonDecode(response.body);
}

Future<File> selectImage() async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  final File tempImage = File(image!.path);
  return tempImage;
}

Future<String> imageToBase64(File image) async {
  final imageContent = await image.readAsBytes();
  final base64Image = base64Encode(imageContent);
  return base64Image;
}

void fillUserInfo(BuildContext context, String fullName, String? imagePath) {
  final model = Provider.of<UserInfo>(context, listen: false);

  model.setAttribute('fullName', fullName);
  if (imagePath != null) {
    model.setAttribute('imagePath', imagePath);
  }
}
