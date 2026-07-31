import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_ai/main.dart';

void main() {
  testWidgets('WeekendAI splash screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeekendAIApp());

    // Verify key titles exist in widget tree
    expect(find.text('WeekendAI'), findsOneWidget);
    expect(find.text('Your AI Companion for Every Weekend'), findsOneWidget);
  });
}
