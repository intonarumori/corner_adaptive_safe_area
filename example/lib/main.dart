import 'package:corner_margin_ios/corner_margin_ios.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => CornerMarginScope(child: child ?? const SizedBox()),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CornerAdaptiveBuilder(
      builder: (context, insets) {
        // Only reserve AppBar leading space for a real hazard, not the
        // baseline iPad readable-content margin.
        final left = insets.left;
        return Scaffold(
          backgroundColor: const Color(0xFF101217),
          appBar: AppBar(
            title: const Text('CornerAdaptiveSafeArea Demo'),
            leadingWidth: left + 50,
            toolbarHeight: 44,
            leading: Container(
              color: Colors.blue,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(color: Colors.green, width: 50, height: 50),
              ),
            ),
          ),
          body: Stack(
            children: [
              CornerAdaptiveSafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _DemoButton(label: 'Back', color: Colors.amber),
                    _DemoButton(label: 'Title', color: Colors.teal),
                    _DemoButton(label: 'Close', color: Colors.pinkAccent),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(padding: EdgeInsets.all(16), child: _InsetsReadout()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InsetsReadout extends StatelessWidget {
  const _InsetsReadout();

  @override
  Widget build(BuildContext context) {
    final insets = CornerMargin.of(context);
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white70, fontSize: 12),
      child: Text('root insets: $insets'),
    );
  }
}
