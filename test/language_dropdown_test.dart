import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app_state.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Language dropdown test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({'preferredLang': 'en'});

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Wait for the app to finish loading
    await tester.pumpAndSettle();

    // Verify that the dropdown shows the correct initial language
    expect(find.text('English (EN)'), findsOneWidget);

    // Tap the dropdown to open it
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();

    // Tap on the 'Português (Brasil)' option
    await tester.tap(find.text('Português (Brasil)').last);
    await tester.pumpAndSettle();

    // Verify that the dropdown now shows the new language
    expect(find.text('Português (Brasil)'), findsOneWidget);
  });
}
