import 'package:corner_margin_ios/corner_margin_ios_method_channel.dart';
import 'package:corner_margin_ios/corner_margin_ios_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('method channel implementation is the default platform instance', () {
    expect(
      CornerMarginIosPlatform.instance,
      isA<MethodChannelCornerMarginIos>(),
    );
  });
}
