import 'package:flutter/material.dart';

enum AppEnvironment { DEV, STAGE, PROD }

class AppConfig {
  // Singleton object
  static final AppConfig _singleton = new AppConfig._internal();

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();
  AppEnvironment appEnvironment;
  String appName;
  String desc;
  String serverUrl;
  String port;
  ThemeData themeData;

  void setAppConfig(
      {AppEnvironment appEnvironment,
      String appName,
      String desc,
      String serverUrl,
      String port,
      ThemeData themedata}) {
    this.appEnvironment = appEnvironment;
    this.appName = appName;
    this.desc = desc;
    this.serverUrl = serverUrl;
    this.port = port;
    this.themeData = themedata;
  }
}
