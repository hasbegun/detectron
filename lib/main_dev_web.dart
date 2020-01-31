import 'package:flutter/material.dart';
import 'package:lens/configs/app_config.dart';
//import 'package:lens/control/web_app.dart';
import 'package:lens/views/web_upload.dart';
import 'package:lens/views/file_load_test.dart';
import 'package:lens/views/web_upload2.dart';

void main() {
  AppConfig().setAppConfig(
      appEnvironment: AppEnvironment.DEV,
      appName: 'Lens Dev Web',
      desc: 'Image analysis',
      protocol: 'http',
      server: 'localhost',
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
//      home: FileUploadApp(),
      home: FileUploadApp2(
          AppConfig().protocol, AppConfig().server, AppConfig().port),
    );
  }
}
