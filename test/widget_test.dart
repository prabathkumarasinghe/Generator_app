import 'package:flutter_test/flutter_test.dart';

import 'package:generator_app/main.dart';

void main() {
  testWidgets('shows the fuel tracker home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Fuel Tracker'), findsOneWidget);
    expect(find.text('Runtime'), findsOneWidget);
    expect(find.text('Fuel'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
