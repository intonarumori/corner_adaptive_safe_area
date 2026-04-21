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

  testWidgets(
      're-measures across a render-only animation that does not rebuild the child',
      (tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(milliseconds: 100),
    );
    addTearDown(controller.dispose);

    EdgeInsets? received;

    await _pumpWithSurface(
      tester,
      Directionality(
        textDirection: TextDirection.ltr,
        child: CornerMargin(
          corners: _fourCorners,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: controller,
                // `child` is hoisted: AnimatedBuilder rebuilds the
                // Transform every tick, but does NOT rebuild the
                // CornerAdaptiveBuilder. Position changes come solely
                // from the Transform's paint matrix.
                child: CornerAdaptiveBuilder(
                  builder: (_, insets) {
                    received = insets;
                    return const SizedBox(width: 40, height: 40);
                  },
                ),
                builder: (context, child) {
                  final t = controller.value;
                  return Transform.translate(
                    offset: Offset(100 * (1 - t), 100 * (1 - t)),
                    child: child,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    // At t=0 the widget is translated to (100, 100) — away from every
    // hazard — so insets resolve to zero.
    await tester.pump();
    expect(received, EdgeInsets.zero);

    controller.forward();
    await tester.pumpAndSettle();

    // At t=1 the widget sits at (0, 0)–(40, 40), overlapping only the
    // top-left hazard (0, 0, 10, 11).
    expect(received, const EdgeInsets.fromLTRB(10, 11, 0, 0));
  });
}
