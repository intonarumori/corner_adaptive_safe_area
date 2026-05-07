// Exercises the Dart surface under Android conditions. On Android the
// `corner_adaptive_safe_area` plugin registers no native side (pubspec.yaml
// only declares the iOS plugin class), so method-channel calls resolve to
// zero and the event-channel stream never produces non-zero values.
// These tests use the real `MethodChannelCornerAdaptiveSafeArea` with no
// mock handlers to assert the package is a safe no-op in that host.

import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area.dart';
import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area_method_channel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _kSurfaceSize = Size(400, 300);

void _fixSurface(WidgetTester tester) {
  tester.view.physicalSize = _kSurfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getInsets returns zero when no native handler is registered', () async {
    final platform = MethodChannelCornerAdaptiveSafeArea();

    expect(await platform.getInsets(), CornerInsets.zero);
  });

  testWidgets('CornerMarginScope renders on Android and keeps insets at zero', (
    tester,
  ) async {
    _fixSurface(tester);

    CornerInsets? observed;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CornerMarginScope(
          child: Builder(
            builder: (context) {
              observed = CornerMargin.of(context);
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(observed, CornerInsets.zero);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CornerAdaptiveSafeArea applies zero padding on Android', (
    tester,
  ) async {
    _fixSurface(tester);

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CornerMarginScope(
          child: CornerAdaptiveSafeArea(child: SizedBox.expand()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final padding = tester
        .widgetList<Padding>(
          find.descendant(
            of: find.byType(CornerAdaptiveSafeArea),
            matching: find.byType(Padding),
          ),
        )
        .first
        .padding;

    expect(padding, EdgeInsets.zero);
    expect(tester.takeException(), isNull);
  });
}
