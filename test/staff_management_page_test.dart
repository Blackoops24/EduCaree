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

Finder dropdownWithLabel(String label) {
  return find.ancestor(
    of: find.text(label),
    matching: find.byType(DropdownButtonFormField<String>),
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
    await tester.pumpAndSettle();

    expect(find.text('Missing required field: Full Name'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    final drawerRect = tester.getRect(
      find.byKey(const Key('staff_side_drawer')),
    );
    final alertRect = tester.getRect(find.byType(SnackBar));
    expect(alertRect.left, greaterThanOrEqualTo(drawerRect.left));
    expect(alertRect.right, lessThanOrEqualTo(drawerRect.right));
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: fieldWithLabel('Full Name'),
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
    final validationFlash = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(validationFlash.behavior, SnackBarBehavior.floating);
    expect(validationFlash.backgroundColor, Colors.red.shade700);
  });

  testWidgets('employee creation shows success and adds salary record', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));
    await tester.tap(find.text('New Employee'));
    await tester.pumpAndSettle();

    await tester.enterText(fieldWithLabel('Full Name'), 'Test Employee');
    await tester.enterText(fieldWithLabel('Email'), 'employee@example.com');
    await tester.enterText(fieldWithLabel('Mobile Number'), '9876543299');
    await tester.enterText(fieldWithLabel('Qualification'), 'B.Ed');
    await tester.enterText(fieldWithLabel('Monthly Salary'), '50000');
    tester
            .widget<TextFormField>(fieldWithLabel('Joining Date'))
            .controller
            ?.text =
        '2026-06-30';

    await tester.ensureVisible(dropdownWithLabel('Gender'));
    await tester.tap(dropdownWithLabel('Gender'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(dropdownWithLabel('Designation'));
    await tester.tap(dropdownWithLabel('Designation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teacher').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(dropdownWithLabel('Department'));
    await tester.tap(dropdownWithLabel('Department'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Academics').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('staff_submit_button')));
    await tester.tap(find.byKey(const Key('staff_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Employee created successfully.'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar).last).backgroundColor,
      Colors.green.shade700,
    );
    expect(find.textContaining('Test Employee'), findsOneWidget);

    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();
    expect(find.text('Test Employee'), findsOneWidget);
    expect(find.textContaining('₹50000'), findsOneWidget);
  });

  testWidgets('invalid non-empty employee value shows validation alert', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    await tester.enterText(fieldWithLabel('Email'), 'invalid-email');
    await tester.tap(find.byKey(const Key('staff_submit_button')));
    await tester.pump();

    expect(find.text('Invalid field: Email'), findsWidgets);
    expect(find.byKey(const Key('staff_side_drawer')), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar).last).backgroundColor,
      Colors.red.shade700,
    );
  });

  testWidgets('profile edit and operational forms use aligned drawers', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));
    await tester.tap(find.text('New Employee'));
    await tester.pumpAndSettle();
    final registrationRect = tester.getRect(
      find.byKey(const Key('staff_side_drawer')),
    );
    await tester.tap(find.byKey(const Key('staff_cancel_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();
    final profileRect = tester.getRect(
      find.byKey(const Key('staff_side_drawer')),
    );
    expect(profileRect.left, registrationRect.left);
    expect(profileRect.top, registrationRect.top);
    expect(profileRect.width, registrationRect.width);

    await tester.tap(find.byKey(const Key('staff_submit_button')));
    await tester.pumpAndSettle();
    expect(find.text('Employee updated successfully.'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar).last).backgroundColor,
      Colors.blue.shade700,
    );
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Leave'));
    await tester.pumpAndSettle();
    final leaveRect = tester.getRect(
      find.byKey(const Key('staff_leave_drawer')),
    );
    expect(leaveRect.left, registrationRect.left);
    expect(leaveRect.top, registrationRect.top);
    expect(leaveRect.width, registrationRect.width);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Attendance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark Attendance'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('staff_attendance_drawer'))).width,
      registrationRect.width,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Performance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Review'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('staff_performance_drawer'))).width,
      registrationRect.width,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Salary'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('staff_salary_drawer'))).width,
      registrationRect.width,
    );
  });

  testWidgets('default employee salary is visible in salary tab', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StaffManagementPage()));
    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();

    expect(find.text('Rajesh Kumar'), findsOneWidget);
    expect(find.text('Priya Singh'), findsOneWidget);
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
