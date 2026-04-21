import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Per-corner snapshot of the corner-adaptation margins. Each field is the
/// push required to clear the hazard at that specific window corner
/// (window controls, hardware rounding). Values travel as one unit from
/// the native side to [CornerMarginScope].
@immutable
class CornerInsets {
  const CornerInsets({
    this.topLeft = EdgeInsets.zero,
    this.topRight = EdgeInsets.zero,
    this.bottomLeft = EdgeInsets.zero,
    this.bottomRight = EdgeInsets.zero,
  });

  final EdgeInsets topLeft;
  final EdgeInsets topRight;
  final EdgeInsets bottomLeft;
  final EdgeInsets bottomRight;

  static const CornerInsets zero = CornerInsets();

  /// Computes the effective [EdgeInsets] for a widget occupying [rect]
  /// inside a window of size [windowSize].
  ///
  /// For each corner, constructs the hazard rectangle the corner's insets
  /// define (e.g. `Rect.fromLTWH(0, 0, topLeft.left, topLeft.top)`). If
  /// that hazard rect overlaps [rect], folds the corner's two
  /// adjacent-edge values into the result via `max`. A corner whose
  /// insets are zero has a zero-area hazard that overlaps nothing, so it
  /// drops out.
  EdgeInsets effectiveFor(Rect rect, Size windowSize) {
    double left = 0;
    double top = 0;
    double right = 0;
    double bottom = 0;

    final topLeftHazard = Rect.fromLTWH(0, 0, topLeft.left, topLeft.top);
    if (topLeftHazard.overlaps(rect)) {
      left = math.max(left, topLeft.left);
      top = math.max(top, topLeft.top);
    }

    final topRightHazard = Rect.fromLTWH(windowSize.width - topRight.right, 0, topRight.right, topRight.top);
    if (topRightHazard.overlaps(rect)) {
      top = math.max(top, topRight.top);
      right = math.max(right, topRight.right);
    }

    final bottomLeftHazard = Rect.fromLTWH(0, windowSize.height - bottomLeft.bottom, bottomLeft.left, bottomLeft.bottom);
    if (bottomLeftHazard.overlaps(rect)) {
      left = math.max(left, bottomLeft.left);
      bottom = math.max(bottom, bottomLeft.bottom);
    }

    final bottomRightHazard = Rect.fromLTWH(
      windowSize.width - bottomRight.right,
      windowSize.height - bottomRight.bottom,
      bottomRight.right,
      bottomRight.bottom,
    );
    if (bottomRightHazard.overlaps(rect)) {
      right = math.max(right, bottomRight.right);
      bottom = math.max(bottom, bottomRight.bottom);
    }

    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CornerInsets &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);

  @override
  String toString() =>
      'CornerInsets(topLeft: $topLeft, topRight: $topRight, '
      'bottomLeft: $bottomLeft, bottomRight: $bottomRight)';
}
