import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'corner_margin.dart';

/// Signature for [CornerAdaptiveBuilder.builder]: receives the effective
/// corner-adaptation [EdgeInsets] for the widget's own rect.
typedef CornerAdaptiveWidgetBuilder = Widget Function(
  BuildContext context,
  EdgeInsets insets,
);

/// Invokes [builder] with the effective corner-adaptation [EdgeInsets] for
/// its own rect. After each frame, measures the widget's [RenderBox]
/// against the window and computes the applicable insets via
/// [CornerInsets.effectiveFor].
///
/// Use this when you want to *read* the insets and do something other
/// than apply them as padding — e.g. size an `AppBar.leadingWidth` by
/// `insets.left + N`.
///
/// Measurements re-run once per frame as long as any frame is being
/// rendered, so animations that move the widget without rebuilding it
/// (e.g. `SlideTransition`, `Transform`, `AnimatedBuilder` around a
/// `Transform`) still produce up-to-date insets by the end of the
/// animation.
///
/// If you need raw per-corner values, read `CornerMargin.of(context)`
/// directly.
class CornerAdaptiveBuilder extends StatefulWidget {
  const CornerAdaptiveBuilder({super.key, required this.builder});

  final CornerAdaptiveWidgetBuilder builder;

  @override
  State<CornerAdaptiveBuilder> createState() => _CornerAdaptiveBuilderState();
}

class _CornerAdaptiveBuilderState extends State<CornerAdaptiveBuilder> {
  EdgeInsets _effective = EdgeInsets.zero;

  @override
  void initState() {
    super.initState();
    _scheduleMeasure();
  }

  void _scheduleMeasure() {
    SchedulerBinding.instance.addPostFrameCallback(_measure);
  }

  void _measure(Duration _) {
    if (!mounted) return;

    final object = context.findRenderObject();
    if (object is RenderBox && object.hasSize) {
      final corners = CornerMargin.of(context);
      final windowSize = MediaQuery.sizeOf(context);
      final rect = object.localToGlobal(Offset.zero) & object.size;
      final next = corners.effectiveFor(rect, windowSize);

      if (next != _effective) {
        setState(() => _effective = next);
      }
    }

    _scheduleMeasure();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _effective);
  }
}
