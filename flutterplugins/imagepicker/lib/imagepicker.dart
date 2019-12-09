import 'dart:async';

import 'package:flutter/services.dart';

class Imagepicker {
  static const MethodChannel _channel =
      const MethodChannel('imagepicker');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
