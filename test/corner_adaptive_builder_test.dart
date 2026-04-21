import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area.dart';
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

void main() {
  testWidgets('receives computed EdgeInsets for its own rect', (tester) async {
    EdgeInsets? received;

    await _pumpWithSurface(
      tester,
      Directionality(
        textDirection: TextDirection.ltr,
        child: CornerMargin(
          corners: _fourCorners,
          child: CornerAdaptiveBuilder(
            builder: (_, insets) {
              received = insets;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );

    // First build, no measurement yet.
    expect(received, EdgeInsets.zero);

    await tester.pump();

    // Fills the window → touches all 4 corners, flush on all 4 edges.
    expect(received, const EdgeInsets.fromLTRB(14, 12, 16, 17));
  });

  testWidgets('returns zero when no scope present', (tester) async {
    EdgeInsets? received;

    await _pumpWithSurface(
      tester,
      Directionality(
        textDirection: TextDirection.ltr,
        child: CornerAdaptiveBuilder(
          builder: (_, insets) {
            received = insets;
            return const SizedBox.expand();
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(received, EdgeInsets.zero);
  });
}
