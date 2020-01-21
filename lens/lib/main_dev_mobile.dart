import 'package:flutter/material.dart';
import 'package:lens/config/app_config.dart';
import 'package:lens/view/mobile_home.dart';

void main() {
  AppConfig().setAppConfig(
      appEnvironment: AppEnvironment.DEV,
      appName: 'Lens Dev Mobile',
      desc: 'Image analysis',
      serverUrl: 'http://192.168.100.1',
      port: '8888',
      themedata: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.red,
      ));
  runApp(MobileApp());
}

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig().appName,
      theme: AppConfig().themeData,
      home: MobileHome(title: AppConfig().appName),
    );
  }
}
