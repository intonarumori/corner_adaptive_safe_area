import 'package:corner_margin_ios/corner_margin_ios.dart';
import 'package:corner_margin_ios/corner_margin_ios_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, double> _encode(EdgeInsets e) => {
      'top': e.top,
      'leading': e.left,
      'trailing': e.right,
      'bottom': e.bottom,
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelCornerMarginIos();
  const methodChannel = MethodChannel('corner_margin_ios');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  test('getPlatformVersion', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async => '42');

    expect(await platform.getPlatformVersion(), '42');
  });

  test('getInsets parses a four-corner payload', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async {
      return <String, Map<String, double>>{
        'topLeft': _encode(const EdgeInsets.fromLTRB(10, 11, 0, 0)),
        'topRight': _encode(const EdgeInsets.fromLTRB(0, 12, 13, 0)),
        'bottomLeft': _encode(const EdgeInsets.fromLTRB(14, 0, 0, 15)),
        'bottomRight': _encode(const EdgeInsets.fromLTRB(0, 0, 16, 17)),
      };
    });

    expect(
      await platform.getInsets(),
      const CornerInsets(
        topLeft: EdgeInsets.fromLTRB(10, 11, 0, 0),
        topRight: EdgeInsets.fromLTRB(0, 12, 13, 0),
        bottomLeft: EdgeInsets.fromLTRB(14, 0, 0, 15),
        bottomRight: EdgeInsets.fromLTRB(0, 0, 16, 17),
      ),
    );
  });

  test('getInsets returns zero when channel yields null', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (call) async => null);

    expect(await platform.getInsets(), CornerInsets.zero);
  });

  test('watchInsets parses a broadcast event', () async {
    const channelName = 'corner_margin_ios/insets';
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    messenger.setMockStreamHandler(
      const EventChannel(channelName),
      MockStreamHandler.inline(
        onListen: (_, sink) {
          sink.success(<String, Map<String, double>>{
            'topLeft': _encode(const EdgeInsets.fromLTRB(1, 2, 0, 0)),
            'topRight': _encode(const EdgeInsets.fromLTRB(0, 3, 4, 0)),
            'bottomLeft': _encode(const EdgeInsets.fromLTRB(5, 0, 0, 6)),
            'bottomRight': _encode(const EdgeInsets.fromLTRB(0, 0, 7, 8)),
          });
          sink.endOfStream();
        },
      ),
    );

    final first = await platform.watchInsets().first;
    expect(
      first,
      const CornerInsets(
        topLeft: EdgeInsets.fromLTRB(1, 2, 0, 0),
        topRight: EdgeInsets.fromLTRB(0, 3, 4, 0),
        bottomLeft: EdgeInsets.fromLTRB(5, 0, 0, 6),
        bottomRight: EdgeInsets.fromLTRB(0, 0, 7, 8),
      ),
    );
  });
}
