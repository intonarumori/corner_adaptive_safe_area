import 'package:flutter/widgets.dart';

import 'corner_insets.dart';

/// Inherited widget that exposes the current [CornerInsets] (one per
/// window corner) to descendants. Established by [CornerMarginScope] at
/// the app root.
///
/// Most callers don't read this directly; [CornerAdaptiveSafeArea] and
/// [CornerAdaptiveBuilder] look it up and compute per-widget effective
/// [EdgeInsets] via [CornerInsets.effectiveFor]. Read it directly when you
/// need a specific corner's raw values (e.g. sizing an `AppBar.leadingWidth`
/// from `CornerMargin.of(context).topLeft.left`).
class CornerMargin extends InheritedWidget {
  const CornerMargin({
    super.key,
    required this.corners,
    required super.child,
  });

  final CornerInsets corners;

  /// Nearest ancestor [CornerInsets], or [CornerInsets.zero] when no
  /// [CornerMarginScope] has been installed.
  static CornerInsets of(BuildContext context) =>
      maybeOf(context) ?? CornerInsets.zero;

  static CornerInsets? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CornerMargin>()?.corners;

  @override
  bool updateShouldNotify(CornerMargin oldWidget) =>
      corners != oldWidget.corners;
}
