import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'corner_margin_ios_platform_interface.dart';
import 'src/corner_insets.dart';

class MethodChannelCornerMarginIos extends CornerMarginIosPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('corner_margin_ios');

  @visibleForTesting
  final EventChannel eventChannel =
      const EventChannel('corner_margin_ios/insets');

  Stream<CornerInsets>? _stream;

  @override
  Future<String?> getPlatformVersion() {
    return methodChannel.invokeMethod<String>('getPlatformVersion');
  }

  @override
  Future<CornerInsets> getInsets() async {
    final result =
        await methodChannel.invokeMapMethod<String, dynamic>('getInsets');
    return _parseCornerInsets(result);
  }

  @override
  Stream<CornerInsets> watchInsets() {
    return _stream ??= eventChannel
        .receiveBroadcastStream()
        .map<CornerInsets>((event) => _parseCornerInsets(event as Map?))
        .asBroadcastStream();
  }

  static CornerInsets _parseCornerInsets(Map<Object?, Object?>? map) {
    if (map == null) return CornerInsets.zero;
    return CornerInsets(
      topLeft: _parseEdges(map['topLeft'] as Map?),
      topRight: _parseEdges(map['topRight'] as Map?),
      bottomLeft: _parseEdges(map['bottomLeft'] as Map?),
      bottomRight: _parseEdges(map['bottomRight'] as Map?),
    );
  }

  static EdgeInsets _parseEdges(Map<Object?, Object?>? map) {
    if (map == null) return EdgeInsets.zero;
    double read(String key) => (map[key] as num?)?.toDouble() ?? 0;
    return EdgeInsets.fromLTRB(
      read('leading'),
      read('top'),
      read('trailing'),
      read('bottom'),
    );
  }
}
