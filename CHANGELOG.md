## 0.0.1

* Initial release.
* Minimum iOS deployment target: 13.0.
* Corner-adaptation margins from `UIView.directionalEdgeInsets(for: .margins(cornerAdaptation:))` are read at runtime on iOS 26.0+ only; on iOS 13.0–25.x the widgets report `CornerInsets.zero` and render as no-ops.
