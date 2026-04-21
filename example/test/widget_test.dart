import 'package:corner_margin_ios_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Demo app builds without crashing', (tester) async {
    await tester.pumpWidget(const DemoApp());
    expect(find.text('Back'), findsOneWidget);
  });
}
