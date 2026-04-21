import 'package:corner_margin_ios/corner_margin_ios.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _kSurfaceSize = Size(400, 300);
const CornerInsets _fourCorners = CornerInsets(
  topLeft: EdgeInsets.fromLTRB(10, 11, 0, 0),
  topRight: EdgeInsets.fromLTRB(0, 12, 13, 0),
  bottomLeft: EdgeInsets.fromLTRB(14, 0, 0, 15),
  bottomRight: EdgeInsets.fromLTRB(0, 0, 16, 17),
);

Future<void> _pumpWithSurface(
  WidgetTester tester,
  Widget widget,
) async {
  tester.view.physicalSize = _kSurfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(widget);
}

Widget _host({required CornerInsets corners, required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: CornerMargin(corners: corners, child: child),
  );
}

EdgeInsetsGeometry _firstCornerAdaptivePadding(WidgetTester tester) {
  // The widget returns a top-level Padding; pick the first one whose
  // ancestor chain includes a CornerAdaptiveSafeArea Element.
  return tester
      .widgetList<Padding>(find.descendant(
        of: find.byType(CornerAdaptiveSafeArea),
        matching: find.byType(Padding),
      ))
      .first
      .padding;
}

void main() {
  testWidgets('flush on all edges applies max-of-corners per edge',
      (tester) async {
    await _pumpWithSurface(
      tester,
      _host(
        corners: _fourCorners,
        child: const CornerAdaptiveSafeArea(child: SizedBox.expand()),
      ),
    );

    // First frame: no measurement yet, padding is zero.
    expect(_firstCornerAdaptivePadding(tester), EdgeInsets.zero);

    await tester.pump();

    expect(
      _firstCornerAdaptivePadding(tester),
      const EdgeInsets.fromLTRB(14, 12, 16, 17),
    );
  });

  testWidgets('widget centered away from all edges applies no padding',
      (tester) async {
    await _pumpWithSurface(
      tester,
      _host(
        corners: _fourCorners,
        child: const Center(
          child: CornerAdaptiveSafeArea(
            child: SizedBox(width: 10, height: 10),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(_firstCornerAdaptivePadding(tester), EdgeInsets.zero);
  });

  testWidgets('widget flush top-left only pulls topLeft corner values',
      (tester) async {
    await _pumpWithSurface(
      tester,
      _host(
        corners: _fourCorners,
        child: Align(
          alignment: Alignment.topLeft,
          child: CornerAdaptiveSafeArea(
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(
      _firstCornerAdaptivePadding(tester),
      const EdgeInsets.fromLTRB(10, 11, 0, 0),
    );
  });

  testWidgets('nested safe areas do not double-count', (tester) async {
    await _pumpWithSurface(
      tester,
      _host(
        corners: _fourCorners,
        child: const CornerAdaptiveSafeArea(
          child: CornerAdaptiveSafeArea(
            key: ValueKey('inner'),
            child: SizedBox.expand(),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();

    final innerPadding = tester
        .widgetList<Padding>(find.descendant(
          of: find.byKey(const ValueKey('inner')),
          matching: find.byType(Padding),
        ))
        .first
        .padding;
    expect(innerPadding, EdgeInsets.zero);
  });

  testWidgets('disabled edge skips its inset even when flush', (tester) async {
    await _pumpWithSurface(
      tester,
      _host(
        corners: _fourCorners,
        child: const CornerAdaptiveSafeArea(
          left: false,
          top: false,
          child: SizedBox.expand(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(
      _firstCornerAdaptivePadding(tester),
      const EdgeInsets.fromLTRB(0, 0, 16, 17),
    );
  });
}
