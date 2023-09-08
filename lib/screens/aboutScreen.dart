import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('About', style: TextStyle(fontSize: 24)),
      const SizedBox(height: 16),
      Image.asset(
        'assets/images/me.jpg',
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 16),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('รหัสนักศึกษา'),
          Text('64125842'),
        ],
      ),
      const SizedBox(height: 16),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ชื่อ-สกุล'),
          Text('โพธิวรรณ โพธิไทย'),
        ],
      ),
      const SizedBox(height: 16),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('เบอร์โทรศัพท์'),
          Text('087-896-1123'),
        ],
      )
    ]));
  }
}
