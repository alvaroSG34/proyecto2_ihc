// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_flutter/main.dart';
import 'package:frontend_flutter/services/auth_service.dart';

class EmptyTokenStorage implements TokenStorage {
  @override
  Future<String?> read() async => null;

  @override
  Future<void> write(String token) async {}

  @override
  Future<void> delete() async {}
}

void main() {
  testWidgets('shows login when there is no saved token', (tester) async {
    final service = auth_service(storage: EmptyTokenStorage());

    await tester.pumpWidget(MyApp(authService: service));
    await tester.pumpAndSettle();

    expect(find.text('Ingresar'), findsOneWidget);
  });
}
