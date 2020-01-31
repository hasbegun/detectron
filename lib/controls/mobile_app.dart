import 'package:flutter/material.dart';
import 'package:lens/views/mobile_home.dart';

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detectron Lens',
      home: MobileHome(title: 'Detectron Lens'),
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}
