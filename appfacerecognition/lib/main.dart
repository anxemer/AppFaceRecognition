import 'dart:io'; // Thêm import này
import 'package:flutter/material.dart';
import 'screens/face_recognition_screen.dart';
import 'utils/http_overrides.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceRecognitionScreen(),
    );
  }
}
