import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sunu_dekk/app/app.dart';

void main() {
  testWidgets('App boots on LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SunuDekkApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sunu Dekk'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
