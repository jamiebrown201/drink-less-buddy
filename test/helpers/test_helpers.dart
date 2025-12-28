import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:drink_less_buddy/providers/drink_provider_refactored.dart';
import 'package:drink_less_buddy/providers/intention_provider_refactored.dart';
import 'package:drink_less_buddy/providers/user_provider_refactored.dart';
import 'mock_providers.dart';

/// Wraps a widget with Material App and theme for testing
Widget createTestWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

/// Wraps a widget with providers for testing
Widget createTestWidgetWithProviders(
  Widget child, {
  DrinkProvider? drinkProvider,
  IntentionProvider? intentionProvider,
  UserProvider? userProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<DrinkProvider>(
        create: (_) => drinkProvider ?? MockDrinkProvider(),
      ),
      ChangeNotifierProvider<IntentionProvider>(
        create: (_) => intentionProvider ?? MockIntentionProvider(),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (_) => userProvider ?? MockUserProvider(),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

/// Pump and settle with a standard duration
Future<void> pumpAndSettle(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

/// Find text widget by partial match
Finder findTextContaining(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is Text && widget.data?.contains(text) == true,
  );
}

/// Tap and settle
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await pumpAndSettle(tester);
}

/// Enter text and settle
Future<void> enterTextAndSettle(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await pumpAndSettle(tester);
}

/// Scroll until visible
Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder item,
  Finder scrollable, {
  double delta = 100,
}) async {
  await tester.scrollUntilVisible(
    item,
    delta,
    scrollable: scrollable,
  );
  await pumpAndSettle(tester);
}
