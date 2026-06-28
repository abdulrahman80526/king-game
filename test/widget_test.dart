import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_showdown/main.dart';

void main() {
  testWidgets('Navigate to GameScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Choose Game Mode'), findsOneWidget);

    await tester.tap(find.text('Human VS Human'));
    await tester.pumpAndSettle();

    expect(find.text('Human vs Human'), findsOneWidget);
  });
}
