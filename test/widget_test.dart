import 'package:flutter_test/flutter_test.dart';
import 'package:duitly_ats/main.dart';

void main() {
  testWidgets('Duitly smoke test - Splash Screen displays', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DuitlyApp());

    // Verify that Duitly title and tagline are displayed on Splash Screen
    expect(find.text('Duitly'), findsOneWidget);
    expect(find.text('Manage your money, simply.'), findsOneWidget);
  });
}
