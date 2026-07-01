import 'package:educare/core/services/module_persistence_service.dart';
import 'package:educare/features/academics/presentation/pages/academic_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder textFieldWithLabel(String label) {
  return find.ancestor(of: find.text(label), matching: find.byType(TextField));
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

  testWidgets('class CRUD shows totals, validation, and color-coded feedback', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: AcademicManagementPage()));
    expect(find.text('Total: 2'), findsOneWidget);

    await tester.tap(find.text('New Class'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('academic_class_drawer')), findsOneWidget);
    expect(find.text('Total records: 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('academic_class_drawer_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Missing required field: Class Name'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    final drawerRect = tester.getRect(
      find.byKey(const Key('academic_class_drawer')),
    );
    final alertRect = tester.getRect(find.byType(SnackBar));
    expect(alertRect.left, greaterThanOrEqualTo(drawerRect.left));
    expect(alertRect.right, lessThanOrEqualTo(drawerRect.right));
    expect(
      tester
          .widget<TextField>(textFieldWithLabel('Class Name'))
          .focusNode
          ?.hasFocus,
      isTrue,
    );
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.red.shade700,
    );

    await tester.enterText(textFieldWithLabel('Class Name'), 'Class 10');
    await tester.tap(dropdownWithLabel('Section'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('C').last);
    await tester.pumpAndSettle();
    await tester.enterText(textFieldWithLabel('Capacity'), '35');
    await tester.tap(find.byKey(const Key('academic_class_drawer_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Missing required field: Class Teacher'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(textFieldWithLabel('Class Teacher'))
          .focusNode
          ?.hasFocus,
      isTrue,
    );

    await tester.enterText(textFieldWithLabel('Class Teacher'), 'Test Teacher');
    await tester.tap(find.byKey(const Key('academic_class_drawer_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Class 10 - C'), findsOneWidget);
    expect(find.text('Total: 3'), findsOneWidget);
    expect(find.text('Class created successfully.'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar).last).backgroundColor,
      Colors.green.shade700,
    );

    final classCard = find.ancestor(
      of: find.text('Class 10 - C'),
      matching: find.byType(Card),
    );
    await tester.tap(
      find.descendant(of: classCard, matching: find.byTooltip('Edit')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Total records: 3'), findsOneWidget);
    await tester.tap(find.byKey(const Key('academic_class_drawer_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Class updated successfully.'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar).last).backgroundColor,
      Colors.blue.shade700,
    );

    await tester.tap(
      find.descendant(of: classCard, matching: find.byTooltip('Delete')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Class 10 - C'), findsNothing);
    expect(find.text('Total: 2'), findsOneWidget);
  });

  testWidgets('all academic forms use aligned drawers and show totals', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: AcademicManagementPage()));

    await tester.tap(find.text('New Class'));
    await tester.pumpAndSettle();
    final baseRect = tester.getRect(
      find.byKey(const Key('academic_class_drawer')),
    );
    await tester.tap(find.byKey(const Key('academic_class_drawer_cancel')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sections'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Section'));
    await tester.pumpAndSettle();
    final sectionRect = tester.getRect(
      find.byKey(const Key('academic_section_drawer')),
    );
    expect(sectionRect, baseRect);
    await tester.tap(find.byKey(const Key('academic_section_drawer_cancel')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Subjects'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Subject'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('academic_subject_drawer'))),
      baseRect,
    );
    await tester.enterText(textFieldWithLabel('Subject Name'), 'Mathematics');
    await tester.enterText(textFieldWithLabel('Subject Code'), 'MATH');
    await tester.tap(find.byKey(const Key('academic_subject_drawer_submit')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Timetables'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Timetable'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('academic_timetable_drawer'))),
      baseRect,
    );
    await tester.tap(find.byKey(const Key('academic_timetable_drawer_cancel')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Exams'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Exam'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('academic_exam_drawer'))),
      baseRect,
    );
    await tester.enterText(textFieldWithLabel('Exam Name'), 'Mid Term');
    tester
            .widget<TextField>(textFieldWithLabel('Start Date'))
            .controller
            ?.text =
        '2026-07-15';
    await tester.enterText(textFieldWithLabel('Total Marks'), '100');
    await tester.tap(find.byKey(const Key('academic_exam_drawer_submit')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Total Marks: 100'), findsOneWidget);

    await tester.tap(find.text('Marks'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter Marks'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('academic_marks_drawer'))),
      baseRect,
    );
    final totalMarksField = tester.widget<TextField>(
      textFieldWithLabel('Total Marks'),
    );
    expect(totalMarksField.controller?.text, '100');
    await tester.tap(find.byKey(const Key('academic_marks_drawer_cancel')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Report Cards'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate Report Card'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('academic_report_card_drawer'))),
      baseRect,
    );
  });
}
