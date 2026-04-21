import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'corner_adaptive_safe_area_method_channel.dart';
import 'src/corner_insets.dart';

abstract class CornerAdaptiveSafeAreaPlatform extends PlatformInterface {
  CornerAdaptiveSafeAreaPlatform() : super(token: _token);

  static final Object _token = Object();

  static CornerAdaptiveSafeAreaPlatform _instance =
      MethodChannelCornerAdaptiveSafeArea();

  static CornerAdaptiveSafeAreaPlatform get instance => _instance;

  static set instance(CornerAdaptiveSafeAreaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<CornerInsets> getInsets() {
    throw UnimplementedError('getInsets() has not been implemented.');
  }

  Stream<CornerInsets> watchInsets() {
    throw UnimplementedError('watchInsets() has not been implemented.');
  }
}
