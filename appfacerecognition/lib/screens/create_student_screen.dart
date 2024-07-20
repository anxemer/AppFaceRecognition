import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class CreateStudentScreen extends StatefulWidget {
  @override
  _CreateStudentScreenState createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  final _semesterController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createStudent() async {
    if (_image == null) {
      Fluttertoast.showToast(msg: 'No image selected.');
      return;
    }

    try {
      final uri = Uri.parse('https://10.0.2.2:7059/Student/create');
      final request = http.MultipartRequest('POST', uri)
        ..fields['hoTen'] = _nameController.text
        ..fields['tuoi'] = int.tryParse(_ageController.text).toString()
        ..fields['maSoSinhVien'] = _studentIdController.text
        ..fields['nganhHoc'] = _majorController.text
        ..fields['kiHoc'] = int.tryParse(_semesterController.text).toString();

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('file', _image!.path));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Student created successfully');
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Failed to create student.');
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
        title: Text('Create Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            TextField(
              controller: _majorController,
              decoration: InputDecoration(labelText: 'Major'),
            ),
            TextField(
              controller: _semesterController,
              decoration: InputDecoration(labelText: 'Semester'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createStudent,
              child: Text('Create Student'),
            ),
          ],
        ),
      ),
    );
  }
}
