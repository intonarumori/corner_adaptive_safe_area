import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area.dart';
import 'package:corner_adaptive_safe_area_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Demo app builds without crashing', (tester) async {
    await tester.pumpWidget(const DemoApp());
    expect(find.byType(CornerAdaptiveSafeArea), findsNWidgets(6));
  });
}
