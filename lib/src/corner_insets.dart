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
  /// inside a window of size [windowSize]. For each edge of [rect] that is
  /// flush with the matching window edge (within [epsilon]), takes the max
  /// of the values from every corner whose quadrant [rect] overlaps.
  ///
  /// Edges not flush with the window, and corners the rect doesn't reach,
  /// contribute nothing. A widget centred away from all edges receives
  /// [EdgeInsets.zero].
  EdgeInsets effectiveFor(
    Rect rect,
    Size windowSize, {
    double epsilon = 0.5,
  }) {
    final flushLeft = rect.left.abs() <= epsilon;
    final flushTop = rect.top.abs() <= epsilon;
    final flushRight = (rect.right - windowSize.width).abs() <= epsilon;
    final flushBottom = (rect.bottom - windowSize.height).abs() <= epsilon;

    final halfW = windowSize.width / 2;
    final halfH = windowSize.height / 2;
    final touchesTopLeft = rect.left < halfW && rect.top < halfH;
    final touchesTopRight = rect.right > halfW && rect.top < halfH;
    final touchesBottomLeft = rect.left < halfW && rect.bottom > halfH;
    final touchesBottomRight = rect.right > halfW && rect.bottom > halfH;

    double left = 0;
    if (flushLeft) {
      if (touchesTopLeft) left = math.max(left, topLeft.left);
      if (touchesBottomLeft) left = math.max(left, bottomLeft.left);
    }
    double top = 0;
    if (flushTop) {
      if (touchesTopLeft) top = math.max(top, topLeft.top);
      if (touchesTopRight) top = math.max(top, topRight.top);
    }
    double right = 0;
    if (flushRight) {
      if (touchesTopRight) right = math.max(right, topRight.right);
      if (touchesBottomRight) right = math.max(right, bottomRight.right);
    }
    double bottom = 0;
    if (flushBottom) {
      if (touchesBottomLeft) bottom = math.max(bottom, bottomLeft.bottom);
      if (touchesBottomRight) bottom = math.max(bottom, bottomRight.bottom);
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
