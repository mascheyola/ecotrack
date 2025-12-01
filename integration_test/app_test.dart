import 'package:ecotrack/main.dart' as app;
import 'package:ecotrack/wrapper.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app test', (widgetTester) async {
    await widgetTester.pumpWidget(const app.MyApp());
    await widgetTester.pumpAndSettle();

    expect(find.byType(Wrapper), findsOneWidget);
  });
}
