import 'package:flutter_test/flutter_test.dart';
import 'package:nawah/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const NawahApp());
    // Verify app builds without errors
    expect(find.text('نواة'), findsAny);
  });
}
