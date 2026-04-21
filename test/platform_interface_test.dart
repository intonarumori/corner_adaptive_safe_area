import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area_method_channel.dart';
import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('method channel implementation is the default platform instance', () {
    expect(
      CornerAdaptiveSafeAreaPlatform.instance,
      isA<MethodChannelCornerAdaptiveSafeArea>(),
    );
  });
}
