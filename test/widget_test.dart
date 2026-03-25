import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('CEO Journey app builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CEOJourneyApp());

    // Verify that the main app bar title is rendered.
    expect(find.text('CEO Journey'), findsOneWidget);
  });
}
