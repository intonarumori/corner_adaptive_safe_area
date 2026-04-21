import 'dart:async';

import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area.dart';
import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePlatform
    with MockPlatformInterfaceMixin
    implements CornerAdaptiveSafeAreaPlatform {
  final _controller = StreamController<CornerInsets>.broadcast();

  @override
  Future<String?> getPlatformVersion() async => 'test';

  @override
  Future<CornerInsets> getInsets() async => CornerInsets.zero;

  @override
  Stream<CornerInsets> watchInsets() => _controller.stream;

  void emit(CornerInsets insets) => _controller.add(insets);
}

void main() {
  testWidgets('scope publishes stream values via CornerMargin', (tester) async {
    final fake = _FakePlatform();
    CornerInsets? observed;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CornerMarginScope(
          platform: fake,
          child: Builder(
            builder: (context) {
              observed = CornerMargin.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(observed, CornerInsets.zero);

    const next = CornerInsets(
      topLeft: EdgeInsets.fromLTRB(10, 11, 0, 0),
      topRight: EdgeInsets.fromLTRB(0, 12, 13, 0),
      bottomLeft: EdgeInsets.fromLTRB(14, 0, 0, 15),
      bottomRight: EdgeInsets.fromLTRB(0, 0, 16, 17),
    );
    fake.emit(next);
    await tester.pump();
    await tester.pump();

    expect(observed, next);
  });
}
