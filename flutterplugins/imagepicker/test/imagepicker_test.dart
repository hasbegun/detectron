import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imagepicker/imagepicker.dart';

void main() {
  const MethodChannel channel = MethodChannel('imagepicker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Imagepicker.platformVersion, '42');
  });
}
