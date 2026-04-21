import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'corner_margin.dart';

/// Pads [child] by the corner-adaptation insets that apply to the widget's
/// own rect. After each layout, measures its [RenderBox] against the
/// window and, for every edge flush with a window edge, takes the max of
/// the values from the corners whose quadrants the widget overlaps
/// (see [CornerInsets.effectiveFor]).
///
/// A widget centred away from all edges receives no padding. A widget
/// flush-top but narrow and centred touches both top corners and receives
/// `max(topLeft.top, topRight.top)`. A widget only flush-top near the
/// leading edge receives `topLeft.top`.
///
/// Nested safe areas do not double-count: the inner widget is offset by
/// the outer's padding and therefore measures as non-flush, so it pads by
/// zero. No inherited-widget consumption required.
///
/// Set [left] / [right] / [top] / [bottom] to `false` to skip a specific
/// physical edge even when flush.
class CornerAdaptiveSafeArea extends StatefulWidget {
  const CornerAdaptiveSafeArea({
    super.key,
    required this.child,
    this.left = true,
    this.right = true,
    this.top = true,
    this.bottom = true,
  });

  final Widget child;
  final bool left;
  final bool right;
  final bool top;
  final bool bottom;

  @override
  State<CornerAdaptiveSafeArea> createState() =>
      _CornerAdaptiveSafeAreaState();
}

class _CornerAdaptiveSafeAreaState extends State<CornerAdaptiveSafeArea> {
  EdgeInsets _effective = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_measure);

    final padding = EdgeInsets.fromLTRB(
      widget.left ? _effective.left : 0,
      widget.top ? _effective.top : 0,
      widget.right ? _effective.right : 0,
      widget.bottom ? _effective.bottom : 0,
    );

    return Padding(padding: padding, child: widget.child);
  }

  void _measure(Duration _) {
    if (!mounted) return;
    final object = context.findRenderObject();
    if (object is! RenderBox || !object.hasSize) return;

    final corners = CornerMargin.of(context);
    final windowSize = MediaQuery.sizeOf(context);
    final rect = object.localToGlobal(Offset.zero) & object.size;
    final next = corners.effectiveFor(rect, windowSize);

    if (next == _effective) return;
    setState(() => _effective = next);
  }
}
