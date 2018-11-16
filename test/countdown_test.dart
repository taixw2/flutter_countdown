import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_countdown/countdown.dart';

void main() {
  testWidgets('test widget', (WidgetTester tester) async {
    const DEFAULT_LABEL = 'default label';
    const BEGIN_COUNT = 5;
    final countDownWidget = CountDown(
      beginCount: BEGIN_COUNT,
      endCount: 0,
      renderSemanticLabel: (count) {
        if (count == BEGIN_COUNT) {
          return DEFAULT_LABEL;
        }
        return '$count';
      },
      onPress: (_) {
        return Future.value(true);
      },
    );

    await tester.pumpWidget(countDownWidget);
    expect(find.text(DEFAULT_LABEL), findsOneWidget);
  });
}
