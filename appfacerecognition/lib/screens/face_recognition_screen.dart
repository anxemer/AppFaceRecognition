import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'recognition_result_screen.dart';
import 'create_student_screen.dart';

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadAndRecognizeFace() async {
    if (_image == null) {
      Fluttertoast.showToast(msg: 'No image selected.');
      return;
    }

    try {
      print('ALO');
      final uri =
          Uri.parse('https://10.87.17.232:7059/Recognition/recognize-face');
      // final uri = Uri.parse('https://10.0.2.2:7059/Recognition/recognize-face');
      print('ALO1');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path));
      print('ALO2');
      final response = await request.send();
      print('ALO4');
      final responseBody = await response.stream.bytesToString();
      print('ALO3');
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      final decodedResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecognitionResultScreen(data: decodedResponse),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'No matching student found.');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Take a Photo'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Pick from Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadAndRecognizeFace,
              child: Text('Recognize Face'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateStudentScreen(),
                  ),
                );
              },
              child: Text('Add New Student'),
            ),
          ],
        ),
      ),
    );
  }
}
