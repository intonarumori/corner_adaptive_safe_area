import 'package:corner_margin_ios/corner_margin_ios.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const window = Size(400, 300);
  const corners = CornerInsets(
    topLeft: EdgeInsets.fromLTRB(10, 11, 0, 0),
    topRight: EdgeInsets.fromLTRB(0, 12, 13, 0),
    bottomLeft: EdgeInsets.fromLTRB(14, 0, 0, 15),
    bottomRight: EdgeInsets.fromLTRB(0, 0, 16, 17),
  );

  test('rect covering the whole window intersects every hazard', () {
    final effective = corners.effectiveFor(Offset.zero & window, window);
    expect(effective, const EdgeInsets.fromLTRB(14, 12, 16, 17));
  });

  test('rect inside the top-left quadrant but beyond the hazard yields zero', () {
    // topLeft hazard is (0, 0, 10, 11); rect starts past it.
    const rect = Rect.fromLTWH(20, 20, 50, 50);
    expect(corners.effectiveFor(rect, window), EdgeInsets.zero);
  });

  test('rect overlapping the top-left hazard pulls topLeft only', () {
    const rect = Rect.fromLTWH(0, 0, 50, 50);
    expect(
      corners.effectiveFor(rect, window),
      const EdgeInsets.fromLTRB(10, 11, 0, 0),
    );
  });

  test('rect spanning the top edge intersects topLeft + topRight hazards', () {
    const rect = Rect.fromLTWH(0, 0, 400, 20);
    expect(
      corners.effectiveFor(rect, window),
      const EdgeInsets.fromLTRB(10, 12, 13, 0),
    );
  });

  test('rect in the centre that misses every hazard yields zero', () {
    const rect = Rect.fromLTWH(50, 50, 300, 200);
    expect(corners.effectiveFor(rect, window), EdgeInsets.zero);
  });

  test('rect reaching the bottom-right hazard pulls bottomRight only', () {
    final rect = Rect.fromLTWH(window.width - 40, window.height - 40, 40, 40);
    expect(
      corners.effectiveFor(rect, window),
      const EdgeInsets.fromLTRB(0, 0, 16, 17),
    );
  });

  test('zero-area hazards contribute nothing', () {
    const zero = CornerInsets.zero;
    expect(zero.effectiveFor(Offset.zero & window, window), EdgeInsets.zero);
  });
}
