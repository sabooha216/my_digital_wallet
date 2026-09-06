import 'package:flutter_test/flutter_test.dart';
import 'package:my_digital_wallet/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MyDigitalWalletApp(
        initialLoginState: false,
        initialUsername: '',
      ),
    );
  });
}