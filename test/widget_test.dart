import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_sandoy/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MandelaApp());
    expect(find.text("Mandela - Today's Classes"), findsOneWidget);
  });
}