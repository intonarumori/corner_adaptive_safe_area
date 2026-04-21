## 0.0.1

* Initial release.
* Minimum iOS deployment target: 13.0.
* Corner-adaptation margins from `UIView.directionalEdgeInsets(for: .margins(cornerAdaptation:))` are read at runtime on iOS 26.0+ only; on iOS 13.0–25.x the widgets report `CornerInsets.zero` and render as no-ops.
* `CornerAdaptiveSafeArea` and `CornerAdaptiveBuilder` re-measure once per rendered frame, so animations that move the widget without rebuilding it (`SlideTransition`, `Transform`, `AnimatedBuilder` wrapping a `Transform`) produce up-to-date insets by the end of the animation.
