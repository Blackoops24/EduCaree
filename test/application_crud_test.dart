import 'package:educare/features/academics/presentation/pages/class_management_page.dart';
import 'package:educare/core/services/module_persistence_service.dart';
import 'package:educare/features/calendar/presentation/pages/calendar_overview_page.dart';
import 'package:educare/features/messages/presentation/pages/message_center_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => ModulePersistenceService.instance.enabled = false);

  testWidgets('calendar supports create update and delete', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CalendarOverviewPage())));

    await tester.tap(find.text('New Event'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Test Event');
    await tester.enterText(find.byType(TextField).at(1), '10:00 AM');
    await tester.enterText(find.byType(TextField).at(2), 'Test Hall');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Test Event'), findsOneWidget);

    final eventCard = find.ancestor(of: find.text('Test Event'), matching: find.byType(Card));
    await tester.tap(find.descendant(of: eventCard, matching: find.byIcon(Icons.edit_outlined)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Updated Event');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Updated Event'), findsOneWidget);

    final updatedCard = find.ancestor(of: find.text('Updated Event'), matching: find.byType(Card));
    await tester.tap(find.descendant(of: updatedCard, matching: find.byIcon(Icons.delete_outline)));
    await tester.pump();
    expect(find.text('Updated Event'), findsNothing);
  });

  testWidgets('message center supports create update and delete', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: MessageCenterPage())));

    await tester.tap(find.text('New Message'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Test Team');
    await tester.enterText(find.byType(TextField).at(1), 'Original message');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Original message'), findsOneWidget);

    final messageCard = find.ancestor(of: find.text('Original message'), matching: find.byType(Card));
    await tester.tap(find.descendant(of: messageCard, matching: find.byIcon(Icons.edit_outlined)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), 'Updated message');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Updated message'), findsOneWidget);

    final updatedCard = find.ancestor(of: find.text('Updated message'), matching: find.byType(Card));
    await tester.tap(find.descendant(of: updatedCard, matching: find.byIcon(Icons.delete_outline)));
    await tester.pump();
    expect(find.text('Updated message'), findsNothing);
  });

  testWidgets('standalone class route supports create update and delete', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ClassManagementPage()));

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Class 12-A');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Class 12-A'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Class 12-B');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Class 12-B'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
    expect(find.text('Class 12-B'), findsNothing);
  });
}
