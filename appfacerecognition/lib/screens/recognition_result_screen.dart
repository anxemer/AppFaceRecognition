import 'package:flutter/material.dart';

class RecognitionResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  RecognitionResultScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognition Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${data['hoTen']}', style: TextStyle(fontSize: 20)),
            Text('Age: ${data['tuoi']}', style: TextStyle(fontSize: 20)),
            Text('Student ID: ${data['maSoSinhVien']}',
                style: TextStyle(fontSize: 20)),
            Text('Major: ${data['nganhHoc']}', style: TextStyle(fontSize: 20)),
            Text('Semester: ${data['kiHoc']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
