import 'package:flutter_test/flutter_test.dart';
import 'package:phantom/main.dart';

void main() {
  testWidgets('PHANTOM dashboard renders and navigation works',
      (tester) async {
    await tester.pumpWidget(const PhantomApp());

    expect(find.text('PHANTOM'), findsOneWidget);
    expect(find.text('داشبورد امروز'), findsOneWidget);

    await tester.tap(find.text('وظایف').last);
    await tester.pumpAndSettle();

    expect(find.text('افزودن وظیفه'), findsOneWidget);
  });
}
