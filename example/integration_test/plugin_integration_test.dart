import 'package:corner_margin_ios/corner_margin_ios.dart';
import 'package:corner_margin_ios/corner_margin_ios_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getInsets returns a concrete CornerInsets from the host',
      (tester) async {
    final CornerInsets corners =
        await CornerMarginIosPlatform.instance.getInsets();
    expect(corners, isA<CornerInsets>());
  });
}
