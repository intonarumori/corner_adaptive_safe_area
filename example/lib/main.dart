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
    return Scaffold(
      backgroundColor: const Color(0xFF101217),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CornerAdaptiveSafeArea(child: Container(color: Colors.green)),
                ),
                Expanded(
                  child: CornerAdaptiveSafeArea(child: Container(color: Colors.red)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CornerAdaptiveSafeArea(child: Container(color: Colors.brown)),
                ),
                Expanded(
                  child: CornerAdaptiveSafeArea(child: Container(color: Colors.teal)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CornerAdaptiveSafeArea(child: Container(color: Colors.blue)),
                ),
                Expanded(
                  child: CornerAdaptiveSafeArea(child: Container(color: Colors.orange)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
