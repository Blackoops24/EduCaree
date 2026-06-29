import 'package:educare/core/services/module_persistence_service.dart';
import 'package:educare/features/staff/presentation/pages/staff_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder fieldWithLabel(String label) {
  return find.ancestor(
    of: find.text(label),
    matching: find.byType(TextFormField),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => ModulePersistenceService.instance.enabled = false);

  testWidgets('new employee opens a Student-style side drawer', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));
    await tester.tap(find.text('New Employee'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('staff_side_drawer')), findsOneWidget);
    expect(find.byKey(const Key('staff_cancel_button')), findsOneWidget);
    expect(find.byKey(const Key('staff_submit_button')), findsOneWidget);
    expect(find.text('Employee ID'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Designation'), findsOneWidget);
    expect(find.text('Department'), findsOneWidget);
    expect(find.text('Employment Type'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
  });

  testWidgets('employee registration validates required contact fields', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));
    await tester.tap(find.text('New Employee'));
    await tester.pumpAndSettle();
    await tester.enterText(fieldWithLabel('Email'), 'invalid');
    await tester.enterText(fieldWithLabel('Mobile Number'), '1234');
    await tester.tap(find.byKey(const Key('staff_submit_button')));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
  });

  testWidgets('staff module exposes all operational tabs', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));

    for (final tab in [
      'Registration',
      'Profile',
      'Leave',
      'Attendance',
      'Performance',
      'Salary',
    ]) {
      expect(find.text(tab), findsOneWidget);
    }
  });
}
