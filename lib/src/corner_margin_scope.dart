import 'dart:async';

import 'package:flutter/widgets.dart';

import '../corner_adaptive_safe_area_platform_interface.dart';
import 'corner_insets.dart';
import 'corner_margin.dart';

/// Subscribes to the plugin's per-corner stream once and publishes the
/// live [CornerInsets] into the tree via [CornerMargin].
///
/// Wrap your app near the root — typically via `MaterialApp.builder` — so
/// every [CornerAdaptiveSafeArea] and [CornerAdaptiveBuilder] below can
/// read the values.
class CornerMarginScope extends StatefulWidget {
  const CornerMarginScope({
    super.key,
    required this.child,
    @visibleForTesting this.platform,
  });

  final Widget child;

  /// Injectable for tests. Defaults to
  /// [CornerAdaptiveSafeAreaPlatform.instance].
  final CornerAdaptiveSafeAreaPlatform? platform;

  @override
  State<CornerMarginScope> createState() => _CornerMarginScopeState();
}

class _CornerMarginScopeState extends State<CornerMarginScope> {
  late StreamSubscription<CornerInsets> _subscription;
  CornerInsets _corners = CornerInsets.zero;

  CornerAdaptiveSafeAreaPlatform get _platform =>
      widget.platform ?? CornerAdaptiveSafeAreaPlatform.instance;

  @override
  void initState() {
    super.initState();
    _subscription = _platform.watchInsets().listen((corners) {
      if (!mounted || corners == _corners) return;
      setState(() => _corners = corners);
    });
    // Belt-and-braces bootstrap: the first event from the stream can be
    // delayed (the Flutter root view may not be laid out yet when the
    // plugin registers). Query once eagerly so the first paint has a value.
    _platform.getInsets().then((corners) {
      if (!mounted || corners == _corners) return;
      setState(() => _corners = corners);
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CornerMargin(corners: _corners, child: widget.child);
  }
}
