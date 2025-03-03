import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(YogaPoseApp());
}

class YogaPoseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ท่าโยคะ / Yoga Pose',
      theme: ThemeData(
        primaryColor: Colors.blue[200],
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Prompt',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}