import 'package:flutter/material.dart';
import 'screens/main_screen/main_screen_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Cubit App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreenProvider(),
    );
  }
}