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
}
