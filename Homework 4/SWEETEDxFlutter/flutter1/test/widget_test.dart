import 'package:flutter_test/flutter_test.dart';
import 'package:flutter1/homescreen.dart';

void main() {
  testWidgets('App title is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MySearchPage());

    // Verify that the app title is displayed.
    expect(find.text('SWEETEDx Dreams'), findsOneWidget);
  });
}
