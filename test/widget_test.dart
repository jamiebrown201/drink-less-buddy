// Basic smoke test for the Drink Less Buddy app.
import 'package:flutter_test/flutter_test.dart';
import 'package:drink_less_buddy/main.dart';

import 'helpers/test_helpers.dart';

void main() {
  testWidgets('App initializes and shows loading screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      createTestWidgetWithProviders(const AppInitializer()),
    );

    // Verify the initializer shows a loading indicator
    expect(find.text('Initializing...'), findsOneWidget);
  });
}
