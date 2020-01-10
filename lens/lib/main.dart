import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_pages.dart';
import 'package:logger/logger.dart';

void main() {
  final logger = Logger();
  logger.i('Platform $kIsWeb');
  if (Platform.isAndroid || Platform.isIOS) {
    runApp(Home());
  }
}
