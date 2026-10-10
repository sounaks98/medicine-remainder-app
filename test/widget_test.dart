import 'package:flutter_test/flutter_test.dart';

import 'package:medicine_remainder_app/app/app.dart';

void main() {
  testWidgets('Medicine list home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MedicineReminderApp());

    expect(find.text('Medicines'), findsOneWidget);
    expect(find.text('No confirmed medicines yet.'), findsOneWidget);
  });
}
