import 'package:flutter/material.dart';
import 'package:lens/config/app_config.dart';
//import 'package:lens/control/web_app.dart';
import 'package:lens/view/web_upload.dart';

void main() {
  AppConfig().setAppConfig(
      appEnvironment: AppEnvironment.DEV,
      appName: 'Lens Dev Web',
      desc: 'Image analysis',
      serverUrl: 'http://192.168.100.1',
      port: '8888',
      themedata: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blue,
      ));
  runApp(WebApp());
}

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig().appName,
      debugShowCheckedModeBanner: false,
      theme: AppConfig().themeData,
      home: FileUploadApp(),
    );
  }
}
