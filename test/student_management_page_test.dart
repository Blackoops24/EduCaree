import 'package:educare/features/students/presentation/pages/student_management_page.dart';
import 'package:educare/core/services/module_persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => ModulePersistenceService.instance.enabled = false);

  testWidgets('new admission opens a side drawer with controlled fields', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('New Admission'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('admission_side_drawer')), findsOneWidget);
    expect(find.byKey(const Key('admission_cancel_button')), findsOneWidget);
    expect(find.byKey(const Key('admission_submit_button')), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Admission Number'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('Blood Group'), findsOneWidget);
    expect(find.text('Section'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(4));

    await tester.tap(find.byKey(const Key('admission_cancel_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('admission_side_drawer')), findsNothing);
  });

  testWidgets('admission validates mobile and Aadhaar numbers', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('New Admission'));
    await tester.pumpAndSettle();

    final mobile = find.byKey(const Key('admission_mobile'));
    final aadhaar = find.byKey(const Key('admission_aadhaar'));
    await tester.enterText(mobile, '12345');
    await tester.enterText(aadhaar, '1234');
    await tester.tap(find.byKey(const Key('admission_submit_button')));
    await tester.pump();

    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
    expect(find.text('Enter a valid 12-digit Aadhaar number'), findsOneWidget);
  });

  testWidgets('profile search filters students by name or admission number', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('student_profile_search_field')), 'edu20261');
    await tester.pump();

    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('Priya Patel'), findsNothing);
  });

  testWidgets('document upload dialog lets users search students', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Documents'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upload Document'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('document_student_search_field')), findsOneWidget);
  });

  testWidgets('document search is compact in the header', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Documents'));
    await tester.pumpAndSettle();

    final searchField = tester.getSize(find.byKey(const Key('student_document_search_field')));
    expect(searchField.width, lessThan(320));
  });

  testWidgets('profile search is compact and aligned in the header', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Profiles'));
    await tester.pumpAndSettle();

    final searchField = tester.getSize(find.byKey(const Key('student_profile_search_field')));
    expect(searchField.width, lessThan(320));
  });

  testWidgets('parent details dialog includes father and mother fields', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Parent Info'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit parent details').first);
    await tester.pumpAndSettle();

    expect(find.text('Father Name'), findsOneWidget);
    expect(find.text('Father Occupation'), findsOneWidget);
    expect(find.text('Father Phone No.'), findsOneWidget);
    expect(find.text('Mother Name'), findsOneWidget);
    expect(find.text('Mother Occupation'), findsOneWidget);
    expect(find.text('Mother Phone No.'), findsOneWidget);
  });

  testWidgets('promotion submit updates search bar with student name', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Promotion'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Promote Student'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Class'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grade 10').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Promote'));
    await tester.pumpAndSettle();

    final searchField = tester.widget<TextField>(find.byKey(const Key('student_promotion_search_field')));
    expect(searchField.controller?.text, 'Aarav Sharma');
  });

  testWidgets('promotion dialog lets users search students', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: StudentManagementPage()));
    await tester.tap(find.text('Promotion'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Promote Student'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('promotion_student_search_field')), findsOneWidget);
  });
}
