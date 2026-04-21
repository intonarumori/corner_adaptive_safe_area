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

  test('widget flush on all edges takes the max of neighbouring corners', () {
    final rect = Offset.zero & window;
    final effective = corners.effectiveFor(rect, window);
    expect(
      effective,
      const EdgeInsets.fromLTRB(
        14, // max(topLeft.left=10, bottomLeft.left=14)
        12, // max(topLeft.top=11, topRight.top=12)
        16, // max(topRight.right=13, bottomRight.right=16)
        17, // max(bottomLeft.bottom=15, bottomRight.bottom=17)
      ),
    );
  });

  test('widget centered away from edges yields zero', () {
    final rect =
        const Rect.fromLTWH(150, 120, 50, 50); // well inside the window
    expect(corners.effectiveFor(rect, window), EdgeInsets.zero);
  });

  test('widget flush top-left only pulls from topLeft corner', () {
    final rect = const Rect.fromLTWH(0, 0, 50, 50);
    final effective = corners.effectiveFor(rect, window);
    expect(effective, const EdgeInsets.fromLTRB(10, 11, 0, 0));
  });

  test('widget spanning top edge picks max of top-left and top-right', () {
    final rect = const Rect.fromLTWH(0, 0, 400, 40);
    final effective = corners.effectiveFor(rect, window);
    expect(
      effective,
      const EdgeInsets.fromLTRB(
        10, // topLeft.left (bottomLeft doesn't contribute, bottom not flush)
        12, // max(topLeft.top, topRight.top)
        13, // topRight.right
        0,
      ),
    );
  });

  test('widget flush bottom-right only pulls from bottomRight corner', () {
    final rect =
        Rect.fromLTWH(window.width - 50, window.height - 40, 50, 40);
    final effective = corners.effectiveFor(rect, window);
    expect(effective, const EdgeInsets.fromLTRB(0, 0, 16, 17));
  });
}
