import 'package:flutter/material.dart';
import 'dart:io';

import 'package:lens/control/web_app.dart';
import 'package:lens/control/mobile_app.dart';

void main() {
  runApp(WebApp());

  bool is_mobile = false;
  if (Platform.isAndroid || Platform.isIOS) is_mobile = true;
  print('Is Mobile $is_mobile');

//  if (is_mobile) {
//    print('runing mobile');
//    runApp(MobileApp());
//  } else {
//    print('runing web');
//    runApp(WebUploadApp());
//  }
//  runApp(WebApp());
}
