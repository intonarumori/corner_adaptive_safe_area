import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area.dart';
import 'package:corner_adaptive_safe_area/corner_adaptive_safe_area_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getInsets returns a concrete CornerInsets from the host',
      (tester) async {
    final CornerInsets corners =
        await CornerAdaptiveSafeAreaPlatform.instance.getInsets();
    expect(corners, isA<CornerInsets>());
  });
}
