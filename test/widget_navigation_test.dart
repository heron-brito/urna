// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


// https://stackoverflow.com/questions/50704647/how-to-test-navigation-via-navigator-in-flutter
// https://iiro.dev/writing-widget-tests-for-navigation-events/ 
// https://developermemos.com/posts/mock-navigator-test-widgets
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:urna/main.dart';
import 'package:urna/pagina_cadidato.dart';

import 'package:mockito/mockito.dart'; 
import 'package:mockito/annotations.dart';


// @GenerateMocks(
//   [],
//   customMocks: [
//     MockSpec<NavigatorObserver>(
//       returnNullOnMissingStub: true,
//     )
//   ],
// )

class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {
  group('MainPage navigation tests', () {
    late NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildMainPage(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MyApp(),

        // This mocked observer will now receive all navigation events
        // that happen in our app.
        navigatorObservers: [mockObserver],
      ));

      // The tester.pumpWidget() call above just built our app widget
      // and triggered the pushObserver method on the mockObserver once.
      // verify(mockObserver.didPush(any!, any));
      // verify(mockObserver.didPush(any, any));ElevatedButton
      // verify(mockObserver.didPush(any, any));
    }

    Future<void> _navigarParaPaginaCandidato(WidgetTester tester) async {
      // Tap the button which should navigate to the details page.
      //
      // By calling tester.pumpAndSettle(), we ensure that all animations
      // have completed before we continue further.
      // await tester.tap(find.byKey(MyApp.navigarParaPaginaCandidatoKey));

      await tester.tap(find.byType(FloatingActionButton));
      expect(find.text('Votar !'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      await tester.enterText(find.byKey(Key('votar')),'a@aol.com');
      await tester.pump(Duration(milliseconds: 400));
      expect(find.text('a@aol.com'), findsOneWidget);
      // await tester.tap(find.byType(TextButton));
      // await tester.pump(Duration(milliseconds: 50-00));

      await tester.tap(find.byKey(Key('navigarParaPaginaCandidatoKey')));
      await tester.pump(Duration(milliseconds: 5000));
      await tester.pumpAndSettle();
      expect(find.text('Votar !'), findsNothing);
    }

    testWidgets(
        'when tapping "navigate to details" button, should navigate to details page',
        (WidgetTester tester) async {
      // TODO: Write the test case here.
      await _buildMainPage(tester);
      await _navigarParaPaginaCandidato(tester);

      // By tapping the button, we should've now navigated to the details
      // page. The didPush() method should've been called...
      // verify(mockObserver.didPush(any!, any));

      expect(find.byType(PaginaCandidato), findsOneWidget);

      expect(find.text('GRUPO!'), findsOneWidget);      
    });
  });
}