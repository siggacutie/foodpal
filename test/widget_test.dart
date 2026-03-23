import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodpal/main.dart';

void main() {
  testWidgets('FoodPal smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FoodPalApp(),
      ),
    );

    // Verify that the app starts.
    expect(find.byType(FoodPalApp), findsOneWidget);
  });
}
