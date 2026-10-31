import 'package:flutter_test/flutter_test.dart';
import 'package:plugmitra/main.dart';

void main() {
  testWidgets('PlugMitraApp launches smoke test with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PlugMitraApp());
    await tester.pump();
    expect(find.text('Charge Smarter. Go Greener.'), findsOneWidget);
  });
}
