import 'package:educare/core/widgets/app_flash_message.dart';
import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:educare/core/widgets/management_drawer.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AcademicManagementPage extends StatefulWidget {
  const AcademicManagementPage({super.key});

  @override
  State<AcademicManagementPage> createState() => _AcademicManagementPageState();
}

class _AcademicManagementPageState
    extends PersistentModuleState<AcademicManagementPage> {
  static const _sectionOptions = ['A', 'B', 'C', 'D'];
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  static const _semesters = ['Term 1', 'Term 2', 'Term 3', 'Annual'];

  final List<ClassRecord> _classes = [
    ClassRecord(
      id: 1,
      name: 'Class 8',
      section: 'A',
      classTeacher: 'Priya Singh',
      capacity: 40,
    ),
    ClassRecord(
      id: 2,
      name: 'Class 9',
      section: 'B',
      classTeacher: 'Ramesh Kumar',
      capacity: 42,
    ),
  ];
  final List<SectionRecord> _sections = [];
  final List<SubjectRecord> _subjects = [];
  final List<TimetableRecord> _timetables = [];
  final List<ExamRecord> _exams = [];
  final List<MarksRecord> _marks = [];
  final List<ReportCard> _reportCards = [];

  final GlobalKey _classesKey = GlobalKey();
  final GlobalKey _sectionsKey = GlobalKey();
  final GlobalKey _subjectsKey = GlobalKey();
  final GlobalKey _timetablesKey = GlobalKey();
  final GlobalKey _examsKey = GlobalKey();
  final GlobalKey _marksKey = GlobalKey();
  final GlobalKey _reportCardsKey = GlobalKey();

  @override
  String get moduleKey => 'academics';

  @override
  Map<String, dynamic> exportState() => {
    'classes': _classes.map((item) => item.toJson()).toList(),
    'sections': _sections.map((item) => item.toJson()).toList(),
    'subjects': _subjects.map((item) => item.toJson()).toList(),
    'timetables': _timetables.map((item) => item.toJson()).toList(),
    'exams': _exams.map((item) => item.toJson()).toList(),
    'marks': _marks.map((item) => item.toJson()).toList(),
    'reportCards': _reportCards.map((item) => item.toJson()).toList(),
  };

  @override
  void importState(Map<String, dynamic> data) {
    _classes
      ..clear()
      ..addAll(
        (data['classes'] as List? ?? []).map(
          (item) =>
              ClassRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _sections
      ..clear()
      ..addAll(
        (data['sections'] as List? ?? []).map(
          (item) =>
              SectionRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _subjects
      ..clear()
      ..addAll(
        (data['subjects'] as List? ?? []).map(
          (item) =>
              SubjectRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _timetables
      ..clear()
      ..addAll(
        (data['timetables'] as List? ?? []).map(
          (item) =>
              TimetableRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _exams
      ..clear()
      ..addAll(
        (data['exams'] as List? ?? []).map(
          (item) => ExamRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _marks
      ..clear()
      ..addAll(
        (data['marks'] as List? ?? []).map(
          (item) =>
              MarksRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
    _reportCards
      ..clear()
      ..addAll(
        (data['reportCards'] as List? ?? []).map(
          (item) => ReportCard.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Academic Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Classes'),
              Tab(text: 'Sections'),
              Tab(text: 'Subjects'),
              Tab(text: 'Timetables'),
              Tab(text: 'Exams'),
              Tab(text: 'Marks'),
              Tab(text: 'Report Cards'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildClassesTab(context),
            _buildSectionsTab(context),
            _buildSubjectsTab(context),
            _buildTimetablesTab(context),
            _buildExamsTab(context),
            _buildMarksTab(context),
            _buildReportCardsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    required int total,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final heading = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          );
          final actions = Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(
                avatar: const Icon(Icons.analytics_outlined, size: 18),
                label: Text('Total: $total'),
              ),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel),
              ),
            ],
          );
          if (constraints.maxWidth < 720) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: 12), actions],
            );
          }
          return Row(
            children: [
              Expanded(child: heading),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _buildClassesTab(BuildContext context) {
    return Column(
      key: _classesKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Class Management',
          subtitle:
              'Create classes, sections, capacity, and teacher ownership.',
          total: _classes.length,
          actionLabel: 'New Class',
          onAction: () => _showClassDrawer(context),
        ),
        Expanded(
          child: _classes.isEmpty
              ? const Center(child: Text('No classes created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _classes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _classes[index];
                    return _recordCard(
                      title: '${record.name} - ${record.section}',
                      subtitle:
                          'Teacher: ${record.classTeacher} • Capacity: ${record.capacity}',
                      onEdit: () => _showClassDrawer(context, record: record),
                      onDelete: () => _deleteClass(context, record),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSectionsTab(BuildContext context) {
    return Column(
      key: _sectionsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Section Management',
          subtitle: 'Assign sections and class teachers to classes.',
          total: _sections.length,
          actionLabel: 'New Section',
          onAction: () =>
              _requireClasses(context, () => _showSectionDrawer(context)),
        ),
        Expanded(
          child: _sections.isEmpty
              ? const Center(child: Text('No sections created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _sections[index];
                    return _recordCard(
                      title: '${record.className} - ${record.name}',
                      subtitle: 'Class Teacher: ${record.classTeacher}',
                      onEdit: () => _showSectionDrawer(context, record: record),
                      onDelete: () => _deleteRecord(
                        context,
                        title: 'Delete section?',
                        message:
                            'This will remove ${record.className} - ${record.name}.',
                        delete: () => _sections.remove(record),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSubjectsTab(BuildContext context) {
    return Column(
      key: _subjectsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Subject Management',
          subtitle: 'Create subject codes and allocate subjects to classes.',
          total: _subjects.length,
          actionLabel: 'New Subject',
          onAction: () =>
              _requireClasses(context, () => _showSubjectDrawer(context)),
        ),
        Expanded(
          child: _subjects.isEmpty
              ? const Center(child: Text('No subjects created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _subjects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _subjects[index];
                    return _recordCard(
                      title: '${record.name} (${record.code})',
                      subtitle: 'Allocated to: ${record.allocatedClass}',
                      onEdit: () => _showSubjectDrawer(context, record: record),
                      onDelete: () => _deleteSubject(context, record),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTimetablesTab(BuildContext context) {
    return Column(
      key: _timetablesKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Timetable Management',
          subtitle: 'Schedule subjects, periods, teachers, and weekdays.',
          total: _timetables.length,
          actionLabel: 'New Timetable',
          onAction: () =>
              _requireSubjects(context, () => _showTimetableDrawer(context)),
        ),
        Expanded(
          child: _timetables.isEmpty
              ? const Center(child: Text('No timetables created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _timetables.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _timetables[index];
                    return _recordCard(
                      title: '${record.className} • ${record.day}',
                      subtitle:
                          '${record.period} • ${record.subject} • ${record.teacher}',
                      onEdit: () =>
                          _showTimetableDrawer(context, record: record),
                      extraAction: IconButton(
                        tooltip: 'Export timetable',
                        icon: const Icon(Icons.download_outlined),
                        onPressed: () => showAppFlashMessage(
                          context,
                          message:
                              'Timetable for ${record.className} exported.',
                          type: AppFlashType.info,
                        ),
                      ),
                      onDelete: () => _deleteRecord(
                        context,
                        title: 'Delete timetable?',
                        message:
                            'This will remove the ${record.day} ${record.period} schedule.',
                        delete: () => _timetables.remove(record),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExamsTab(BuildContext context) {
    return Column(
      key: _examsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Exam Management',
          subtitle: 'Create exams, dates, maximum marks, and hall tickets.',
          total: _exams.length,
          actionLabel: 'New Exam',
          onAction: () => _showExamDrawer(context),
        ),
        Expanded(
          child: _exams.isEmpty
              ? const Center(child: Text('No exams created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _exams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _exams[index];
                    return _recordCard(
                      title: record.name,
                      subtitle:
                          '${record.startDate} • Total Marks: ${record.totalMarks}',
                      onEdit: () => _showExamDrawer(context, record: record),
                      extraAction: TextButton(
                        onPressed: () => showAppFlashMessage(
                          context,
                          message: 'Hall tickets for ${record.name} generated.',
                          type: AppFlashType.success,
                        ),
                        child: const Text('Hall Ticket'),
                      ),
                      onDelete: () => _deleteExam(context, record),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMarksTab(BuildContext context) {
    return Column(
      key: _marksKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Marks Management',
          subtitle: 'Enter marks against an exam and calculate grades.',
          total: _marks.length,
          actionLabel: 'Enter Marks',
          onAction: () =>
              _requireExamAndSubject(context, () => _showMarksDrawer(context)),
        ),
        Expanded(
          child: _marks.isEmpty
              ? const Center(child: Text('No marks entered.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _marks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _marks[index];
                    return _recordCard(
                      title: record.studentName,
                      subtitle:
                          '${record.examName} • ${record.subject} • ${record.marks}/${record.totalMarks} • Grade ${record.grade}',
                      onEdit: () => _showMarksDrawer(context, record: record),
                      onDelete: () => _deleteRecord(
                        context,
                        title: 'Delete marks?',
                        message:
                            'This will remove ${record.subject} marks for ${record.studentName}.',
                        delete: () => _marks.remove(record),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReportCardsTab(BuildContext context) {
    return Column(
      key: _reportCardsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Report Cards',
          subtitle: 'Generate, edit, download, and print report cards.',
          total: _reportCards.length,
          actionLabel: 'Generate Report Card',
          onAction: () =>
              _requireClasses(context, () => _showReportCardDrawer(context)),
        ),
        Expanded(
          child: _reportCards.isEmpty
              ? const Center(child: Text('No report cards generated.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _reportCards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = _reportCards[index];
                    return _recordCard(
                      title: record.studentName,
                      subtitle: '${record.className} • ${record.semester}',
                      onEdit: () =>
                          _showReportCardDrawer(context, record: record),
                      extraAction: Wrap(
                        children: [
                          IconButton(
                            tooltip: 'Download report card',
                            icon: const Icon(Icons.download_outlined),
                            onPressed: () => showAppFlashMessage(
                              context,
                              message:
                                  'Report card for ${record.studentName} downloaded.',
                              type: AppFlashType.info,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Print report card',
                            icon: const Icon(Icons.print_outlined),
                            onPressed: () => showAppFlashMessage(
                              context,
                              message:
                                  'Report card for ${record.studentName} sent to printer.',
                              type: AppFlashType.info,
                            ),
                          ),
                        ],
                      ),
                      onDelete: () => _deleteRecord(
                        context,
                        title: 'Delete report card?',
                        message:
                            'This will remove the report card for ${record.studentName}.',
                        delete: () => _reportCards.remove(record),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _recordCard({
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    Widget? extraAction,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (extraAction != null) extraAction,
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  void _showClassDrawer(BuildContext context, {ClassRecord? record}) {
    final name = TextEditingController(text: record?.name ?? '');
    final teacher = TextEditingController(text: record?.classTeacher ?? '');
    final capacity = TextEditingController(
      text: record?.capacity.toString() ?? '',
    );
    String? section = _sectionOptions.contains(record?.section)
        ? record!.section
        : null;
    final focus = _focusNodes([
      'Class Name',
      'Section',
      'Class Teacher',
      'Capacity',
    ]);
    final isNew = record == null;

    showManagementDrawer(
      context: context,
      anchorKey: _classesKey,
      drawerKey: 'academic_class_drawer',
      title: isNew ? 'New Class' : 'Edit Class',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _classes.length,
      successMessage: isNew
          ? 'Class created successfully.'
          : 'Class updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _field(
            controller: name,
            label: 'Class Name',
            focusNode: focus['Class Name'],
          ),
          _gap,
          _dropdown(
            label: 'Section',
            value: section,
            items: _sectionOptions,
            onChanged: (value) => setDrawerState(() => section = value),
            focusNode: focus['Section'],
          ),
          _gap,
          _field(
            controller: teacher,
            label: 'Class Teacher',
            focusNode: focus['Class Teacher'],
          ),
          _gap,
          _field(
            controller: capacity,
            label: 'Capacity',
            focusNode: focus['Capacity'],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Class Name': name.text,
          'Section': section,
          'Class Teacher': teacher.text,
          'Capacity': capacity.text,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        final parsedCapacity = int.tryParse(capacity.text);
        if (parsedCapacity == null || parsedCapacity <= 0) {
          return _invalid(drawerContext, 'Capacity');
        }
        final duplicate = _classes.any(
          (item) =>
              item != record &&
              item.name.toLowerCase() == name.text.trim().toLowerCase() &&
              item.section == section,
        );
        if (duplicate) {
          return _error(
            drawerContext,
            'This class and section already exists.',
          );
        }
        setState(() {
          if (record == null) {
            _classes.add(
              ClassRecord(
                id: _nextId(_classes.map((item) => item.id)),
                name: name.text.trim(),
                section: section!,
                classTeacher: teacher.text.trim(),
                capacity: parsedCapacity,
              ),
            );
          } else {
            final previousName = record.name;
            record
              ..name = name.text.trim()
              ..section = section!
              ..classTeacher = teacher.text.trim()
              ..capacity = parsedCapacity;
            for (final item in _sections.where(
              (item) => item.className == previousName,
            )) {
              item.className = record.name;
            }
            for (final item in _subjects.where(
              (item) => item.allocatedClass == previousName,
            )) {
              item.allocatedClass = record.name;
            }
            for (final item in _timetables.where(
              (item) => item.className == previousName,
            )) {
              item.className = record.name;
            }
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showSectionDrawer(BuildContext context, {SectionRecord? record}) {
    final teacher = TextEditingController(text: record?.classTeacher ?? '');
    String? className = _classNames.contains(record?.className)
        ? record!.className
        : _firstOrNull(_classNames);
    String? section = _sectionOptions.contains(record?.name)
        ? record!.name
        : null;
    final focus = _focusNodes(['Class', 'Section', 'Class Teacher']);
    final isNew = record == null;
    showManagementDrawer(
      context: context,
      anchorKey: _sectionsKey,
      drawerKey: 'academic_section_drawer',
      title: isNew ? 'New Section' : 'Edit Section',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _sections.length,
      successMessage: isNew
          ? 'Section created successfully.'
          : 'Section updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _dropdown(
            label: 'Class',
            value: className,
            items: _classNames,
            onChanged: (value) => setDrawerState(() => className = value),
            focusNode: focus['Class'],
          ),
          _gap,
          _dropdown(
            label: 'Section',
            value: section,
            items: _sectionOptions,
            onChanged: (value) => setDrawerState(() => section = value),
            focusNode: focus['Section'],
          ),
          _gap,
          _field(
            controller: teacher,
            label: 'Class Teacher',
            focusNode: focus['Class Teacher'],
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Class': className,
          'Section': section,
          'Class Teacher': teacher.text,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        final duplicate = _sections.any(
          (item) =>
              item != record &&
              item.className == className &&
              item.name == section,
        );
        if (duplicate) {
          return _error(drawerContext, 'This class section already exists.');
        }
        setState(() {
          if (record == null) {
            _sections.add(
              SectionRecord(
                id: _nextId(_sections.map((item) => item.id)),
                className: className!,
                name: section!,
                classTeacher: teacher.text.trim(),
              ),
            );
          } else {
            record
              ..className = className!
              ..name = section!
              ..classTeacher = teacher.text.trim();
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showSubjectDrawer(BuildContext context, {SubjectRecord? record}) {
    final name = TextEditingController(text: record?.name ?? '');
    final code = TextEditingController(text: record?.code ?? '');
    String? className = _classNames.contains(record?.allocatedClass)
        ? record!.allocatedClass
        : _firstOrNull(_classNames);
    final focus = _focusNodes([
      'Subject Name',
      'Subject Code',
      'Allocate to Class',
    ]);
    final isNew = record == null;
    showManagementDrawer(
      context: context,
      anchorKey: _subjectsKey,
      drawerKey: 'academic_subject_drawer',
      title: isNew ? 'New Subject' : 'Edit Subject',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _subjects.length,
      successMessage: isNew
          ? 'Subject created successfully.'
          : 'Subject updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _field(
            controller: name,
            label: 'Subject Name',
            focusNode: focus['Subject Name'],
          ),
          _gap,
          _field(
            controller: code,
            label: 'Subject Code',
            focusNode: focus['Subject Code'],
          ),
          _gap,
          _dropdown(
            label: 'Allocate to Class',
            value: className,
            items: _classNames,
            onChanged: (value) => setDrawerState(() => className = value),
            focusNode: focus['Allocate to Class'],
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Subject Name': name.text,
          'Subject Code': code.text,
          'Allocate to Class': className,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        final duplicate = _subjects.any(
          (item) =>
              item != record &&
              item.code.toLowerCase() == code.text.trim().toLowerCase(),
        );
        if (duplicate) {
          return _error(drawerContext, 'Subject code already exists.');
        }
        setState(() {
          if (record == null) {
            _subjects.add(
              SubjectRecord(
                id: _nextId(_subjects.map((item) => item.id)),
                name: name.text.trim(),
                code: code.text.trim().toUpperCase(),
                allocatedClass: className!,
              ),
            );
          } else {
            final previousName = record.name;
            record
              ..name = name.text.trim()
              ..code = code.text.trim().toUpperCase()
              ..allocatedClass = className!;
            for (final item in _timetables.where(
              (item) => item.subject == previousName,
            )) {
              item.subject = record.name;
            }
            for (final item in _marks.where(
              (item) => item.subject == previousName,
            )) {
              item.subject = record.name;
            }
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showTimetableDrawer(BuildContext context, {TimetableRecord? record}) {
    String? className = _classNames.contains(record?.className)
        ? record!.className
        : _firstOrNull(_classNames);
    String day = _days.contains(record?.day) ? record!.day : _days.first;
    String? subject = _subjectNames.contains(record?.subject)
        ? record!.subject
        : _firstOrNull(_subjectNames);
    final teacher = TextEditingController(text: record?.teacher ?? '');
    final period = TextEditingController(text: record?.period ?? '');
    final focus = _focusNodes([
      'Class',
      'Day',
      'Period / Time',
      'Subject',
      'Teacher',
    ]);
    final isNew = record == null;
    showManagementDrawer(
      context: context,
      anchorKey: _timetablesKey,
      drawerKey: 'academic_timetable_drawer',
      title: isNew ? 'New Timetable' : 'Edit Timetable',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _timetables.length,
      successMessage: isNew
          ? 'Timetable created successfully.'
          : 'Timetable updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _dropdown(
            label: 'Class',
            value: className,
            items: _classNames,
            focusNode: focus['Class'],
            onChanged: (value) => setDrawerState(() => className = value),
          ),
          _gap,
          _dropdown(
            label: 'Day',
            value: day,
            items: _days,
            focusNode: focus['Day'],
            onChanged: (value) => setDrawerState(() => day = value ?? day),
          ),
          _gap,
          _field(
            controller: period,
            label: 'Period / Time',
            hintText: '09:00 - 09:45',
            focusNode: focus['Period / Time'],
          ),
          _gap,
          _dropdown(
            label: 'Subject',
            value: subject,
            items: _subjectNames,
            focusNode: focus['Subject'],
            onChanged: (value) => setDrawerState(() => subject = value),
          ),
          _gap,
          _field(
            controller: teacher,
            label: 'Teacher',
            focusNode: focus['Teacher'],
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Class': className,
          'Day': day,
          'Period / Time': period.text,
          'Subject': subject,
          'Teacher': teacher.text,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        final duplicate = _timetables.any(
          (item) =>
              item != record &&
              item.className == className &&
              item.day == day &&
              item.period.toLowerCase() == period.text.trim().toLowerCase(),
        );
        if (duplicate) {
          return _error(
            drawerContext,
            'This class already has a timetable entry for that period.',
          );
        }
        setState(() {
          if (record == null) {
            _timetables.add(
              TimetableRecord(
                id: _nextId(_timetables.map((item) => item.id)),
                className: className!,
                day: day,
                period: period.text.trim(),
                subject: subject!,
                teacher: teacher.text.trim(),
              ),
            );
          } else {
            record
              ..className = className!
              ..day = day
              ..period = period.text.trim()
              ..subject = subject!
              ..teacher = teacher.text.trim();
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showExamDrawer(BuildContext context, {ExamRecord? record}) {
    final name = TextEditingController(text: record?.name ?? '');
    final startDate = TextEditingController(text: record?.startDate ?? '');
    final totalMarks = TextEditingController(text: record?.totalMarks ?? '');
    final focus = _focusNodes(['Exam Name', 'Start Date', 'Total Marks']);
    final isNew = record == null;
    showManagementDrawer(
      context: context,
      anchorKey: _examsKey,
      drawerKey: 'academic_exam_drawer',
      title: isNew ? 'New Exam' : 'Edit Exam',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _exams.length,
      successMessage: isNew
          ? 'Exam created successfully.'
          : 'Exam updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _field(
            controller: name,
            label: 'Exam Name',
            focusNode: focus['Exam Name'],
          ),
          _gap,
          _dateField(
            context: drawerContext,
            controller: startDate,
            label: 'Start Date',
            focusNode: focus['Start Date'],
          ),
          _gap,
          _field(
            controller: totalMarks,
            label: 'Total Marks',
            focusNode: focus['Total Marks'],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Exam Name': name.text,
          'Start Date': startDate.text,
          'Total Marks': totalMarks.text,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        final parsedTotal = int.tryParse(totalMarks.text);
        if (parsedTotal == null || parsedTotal <= 0) {
          return _invalid(drawerContext, 'Total Marks');
        }
        setState(() {
          if (record == null) {
            _exams.add(
              ExamRecord(
                id: _nextId(_exams.map((item) => item.id)),
                name: name.text.trim(),
                startDate: startDate.text,
                totalMarks: parsedTotal.toString(),
              ),
            );
          } else {
            final previousName = record.name;
            record
              ..name = name.text.trim()
              ..startDate = startDate.text
              ..totalMarks = parsedTotal.toString();
            for (final item in _marks.where(
              (item) => item.examName == previousName,
            )) {
              item
                ..examName = record.name
                ..totalMarks = record.totalMarks;
            }
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showMarksDrawer(BuildContext context, {MarksRecord? record}) {
    final student = TextEditingController(text: record?.studentName ?? '');
    final obtained = TextEditingController(text: record?.marks ?? '');
    String? examName = _examNames.contains(record?.examName)
        ? record!.examName
        : _firstOrNull(_examNames);
    String? subject = _subjectNames.contains(record?.subject)
        ? record!.subject
        : _firstOrNull(_subjectNames);
    final total = TextEditingController(
      text: record?.totalMarks ?? _examTotal(examName),
    );
    final focus = _focusNodes([
      'Student Name',
      'Exam',
      'Subject',
      'Marks Obtained',
      'Total Marks',
    ]);
    final isNew = record == null;
    showManagementDrawer(
      context: context,
      anchorKey: _marksKey,
      drawerKey: 'academic_marks_drawer',
      title: isNew ? 'Enter Marks' : 'Edit Marks',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _marks.length,
      successMessage: isNew
          ? 'Marks created successfully.'
          : 'Marks updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _field(
            controller: student,
            label: 'Student Name',
            focusNode: focus['Student Name'],
          ),
          _gap,
          _dropdown(
            label: 'Exam',
            value: examName,
            items: _examNames,
            focusNode: focus['Exam'],
            onChanged: (value) {
              setDrawerState(() {
                examName = value;
                total.text = _examTotal(value);
              });
            },
          ),
          _gap,
          _dropdown(
            label: 'Subject',
            value: subject,
            items: _subjectNames,
            focusNode: focus['Subject'],
            onChanged: (value) => setDrawerState(() => subject = value),
          ),
          _gap,
          _field(
            controller: obtained,
            label: 'Marks Obtained',
            focusNode: focus['Marks Obtained'],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          _gap,
          _field(
            controller: total,
            label: 'Total Marks',
            focusNode: focus['Total Marks'],
            readOnly: true,
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Student Name': student.text,
          'Exam': examName,
          'Subject': subject,
          'Marks Obtained': obtained.text,
          'Total Marks': total.text,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        final marks = int.tryParse(obtained.text);
        final maximum = int.tryParse(total.text);
        if (marks == null || maximum == null || marks < 0 || marks > maximum) {
          return _error(
            drawerContext,
            'Marks must be between 0 and ${total.text}.',
          );
        }
        final percentage = maximum == 0 ? 0 : marks * 100 / maximum;
        final grade = percentage >= 80
            ? 'A'
            : percentage >= 70
            ? 'B'
            : percentage >= 60
            ? 'C'
            : percentage >= 50
            ? 'D'
            : 'F';
        setState(() {
          if (record == null) {
            _marks.add(
              MarksRecord(
                id: _nextId(_marks.map((item) => item.id)),
                studentName: student.text.trim(),
                examName: examName!,
                subject: subject!,
                marks: marks.toString(),
                totalMarks: maximum.toString(),
                grade: grade,
              ),
            );
          } else {
            record
              ..studentName = student.text.trim()
              ..examName = examName!
              ..subject = subject!
              ..marks = marks.toString()
              ..totalMarks = maximum.toString()
              ..grade = grade;
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  void _showReportCardDrawer(BuildContext context, {ReportCard? record}) {
    final student = TextEditingController(text: record?.studentName ?? '');
    String? className = _classNames.contains(record?.className)
        ? record!.className
        : _firstOrNull(_classNames);
    String semester = _semesters.contains(record?.semester)
        ? record!.semester
        : _semesters.first;
    final focus = _focusNodes(['Student Name', 'Class', 'Term / Semester']);
    final isNew = record == null;
    showManagementDrawer(
      context: context,
      anchorKey: _reportCardsKey,
      drawerKey: 'academic_report_card_drawer',
      title: isNew ? 'Generate Report Card' : 'Edit Report Card',
      submitLabel: isNew ? 'Create' : 'Save',
      totalRecords: _reportCards.length,
      successMessage: isNew
          ? 'Report card created successfully.'
          : 'Report card updated successfully.',
      successType: isNew ? AppFlashType.success : AppFlashType.update,
      contentBuilder: (drawerContext, setDrawerState) => Column(
        children: [
          _field(
            controller: student,
            label: 'Student Name',
            focusNode: focus['Student Name'],
          ),
          _gap,
          _dropdown(
            label: 'Class',
            value: className,
            items: _classNames,
            focusNode: focus['Class'],
            onChanged: (value) => setDrawerState(() => className = value),
          ),
          _gap,
          _dropdown(
            label: 'Term / Semester',
            value: semester,
            items: _semesters,
            focusNode: focus['Term / Semester'],
            onChanged: (value) =>
                setDrawerState(() => semester = value ?? semester),
          ),
        ],
      ),
      onSubmit: (drawerContext) async {
        final missing = _firstMissing({
          'Student Name': student.text,
          'Class': className,
          'Term / Semester': semester,
        }, focusNodes: focus);
        if (missing != null) return _missing(drawerContext, missing);
        setState(() {
          if (record == null) {
            _reportCards.add(
              ReportCard(
                id: _nextId(_reportCards.map((item) => item.id)),
                studentName: student.text.trim(),
                className: className!,
                semester: semester,
              ),
            );
          } else {
            record
              ..studentName = student.text.trim()
              ..className = className!
              ..semester = semester;
          }
        });
        await persistNow();
        return true;
      },
    );
  }

  static const _gap = SizedBox(height: 16);

  Widget _field({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    bool readOnly = false,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon: readOnly ? const Icon(Icons.lock_outline) : null,
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    FocusNode? focusNode,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      focusNode: focusNode,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _dateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selected != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(selected);
        }
      },
    );
  }

  List<String> get _classNames =>
      _classes.map((item) => item.name).toSet().toList();
  List<String> get _subjectNames =>
      _subjects.map((item) => item.name).toSet().toList();
  List<String> get _examNames =>
      _exams.map((item) => item.name).toSet().toList();

  String _examTotal(String? examName) {
    final matches = _exams.where((item) => item.name == examName).toList();
    return matches.isEmpty ? '' : matches.first.totalMarks;
  }

  int _nextId(Iterable<int> ids) {
    if (ids.isEmpty) return 1;
    return ids.reduce((a, b) => a > b ? a : b) + 1;
  }

  T? _firstOrNull<T>(List<T> values) {
    return values.isEmpty ? null : values.first;
  }

  Map<String, FocusNode> _focusNodes(Iterable<String> labels) {
    return {for (final label in labels) label: FocusNode()};
  }

  String? _firstMissing(
    Map<String, Object?> fields, {
    Map<String, FocusNode>? focusNodes,
  }) {
    for (final entry in fields.entries) {
      final value = entry.value;
      if (value == null || value.toString().trim().isEmpty) {
        focusNodes?[entry.key]?.requestFocus();
        return entry.key;
      }
    }
    return null;
  }

  bool _missing(BuildContext context, String field) {
    return _error(context, 'Missing required field: $field');
  }

  bool _invalid(BuildContext context, String field) {
    return _error(context, 'Invalid field: $field');
  }

  bool _error(BuildContext context, String message) {
    showAppFlashMessage(context, message: message, type: AppFlashType.error);
    return false;
  }

  void _requireClasses(BuildContext context, VoidCallback action) {
    if (_classes.isEmpty) {
      showAppFlashMessage(
        context,
        message: 'Create a class before adding this record.',
        type: AppFlashType.warning,
      );
      return;
    }
    action();
  }

  void _requireSubjects(BuildContext context, VoidCallback action) {
    if (_classes.isEmpty || _subjects.isEmpty) {
      showAppFlashMessage(
        context,
        message: 'Create a class and subject before adding a timetable.',
        type: AppFlashType.warning,
      );
      return;
    }
    action();
  }

  void _requireExamAndSubject(BuildContext context, VoidCallback action) {
    if (_exams.isEmpty || _subjects.isEmpty) {
      showAppFlashMessage(
        context,
        message: 'Create an exam and subject before entering marks.',
        type: AppFlashType.warning,
      );
      return;
    }
    action();
  }

  Future<void> _deleteRecord(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback delete,
  }) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      title: title,
      message: message,
    );
    if (!confirmed) return;
    setState(delete);
    await persistNow();
    if (!context.mounted) return;
    showAppFlashMessage(
      context,
      message: 'Record deleted successfully.',
      type: AppFlashType.warning,
    );
  }

  Future<void> _deleteClass(BuildContext context, ClassRecord record) async {
    await _deleteRecord(
      context,
      title: 'Delete class?',
      message:
          'This removes ${record.name} and its linked sections, subjects, and timetables.',
      delete: () {
        _classes.remove(record);
        _sections.removeWhere((item) => item.className == record.name);
        final removedSubjects = _subjects
            .where((item) => item.allocatedClass == record.name)
            .map((item) => item.name)
            .toSet();
        _subjects.removeWhere((item) => item.allocatedClass == record.name);
        _timetables.removeWhere(
          (item) =>
              item.className == record.name ||
              removedSubjects.contains(item.subject),
        );
        _marks.removeWhere((item) => removedSubjects.contains(item.subject));
      },
    );
  }

  Future<void> _deleteSubject(
    BuildContext context,
    SubjectRecord record,
  ) async {
    await _deleteRecord(
      context,
      title: 'Delete subject?',
      message:
          'This removes ${record.name} and linked timetable and marks entries.',
      delete: () {
        _subjects.remove(record);
        _timetables.removeWhere((item) => item.subject == record.name);
        _marks.removeWhere((item) => item.subject == record.name);
      },
    );
  }

  Future<void> _deleteExam(BuildContext context, ExamRecord record) async {
    await _deleteRecord(
      context,
      title: 'Delete exam?',
      message: 'This removes ${record.name} and its linked marks entries.',
      delete: () {
        _exams.remove(record);
        _marks.removeWhere((item) => item.examName == record.name);
      },
    );
  }
}

class ClassRecord {
  ClassRecord({
    required this.id,
    required this.name,
    required this.section,
    required this.classTeacher,
    required this.capacity,
  });

  final int id;
  String name;
  String section;
  String classTeacher;
  int capacity;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'section': section,
    'classTeacher': classTeacher,
    'capacity': capacity,
  };

  factory ClassRecord.fromJson(Map<String, dynamic> json) => ClassRecord(
    id: json['id'] as int,
    name: json['name'] as String,
    section: json['section'] as String,
    classTeacher: json['classTeacher'] as String,
    capacity: json['capacity'] as int,
  );
}

class SectionRecord {
  SectionRecord({
    required this.id,
    required this.className,
    required this.name,
    required this.classTeacher,
  });

  final int id;
  String className;
  String name;
  String classTeacher;

  Map<String, dynamic> toJson() => {
    'id': id,
    'className': className,
    'name': name,
    'classTeacher': classTeacher,
  };

  factory SectionRecord.fromJson(Map<String, dynamic> json) => SectionRecord(
    id: json['id'] as int,
    className: json['className'] as String? ?? '',
    name: json['name'] as String,
    classTeacher: json['classTeacher'] as String,
  );
}

class SubjectRecord {
  SubjectRecord({
    required this.id,
    required this.name,
    required this.code,
    required this.allocatedClass,
  });

  final int id;
  String name;
  String code;
  String allocatedClass;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'allocatedClass': allocatedClass,
  };

  factory SubjectRecord.fromJson(Map<String, dynamic> json) => SubjectRecord(
    id: json['id'] as int,
    name: json['name'] as String,
    code: json['code'] as String,
    allocatedClass: json['allocatedClass'] as String,
  );
}

class TimetableRecord {
  TimetableRecord({
    required this.id,
    required this.className,
    required this.day,
    required this.period,
    required this.subject,
    required this.teacher,
  });

  final int id;
  String className;
  String day;
  String period;
  String subject;
  String teacher;

  Map<String, dynamic> toJson() => {
    'id': id,
    'className': className,
    'day': day,
    'period': period,
    'subject': subject,
    'teacher': teacher,
  };

  factory TimetableRecord.fromJson(Map<String, dynamic> json) =>
      TimetableRecord(
        id: json['id'] as int,
        className: json['className'] as String,
        day: json['day'] as String,
        period: json['period'] as String? ?? 'Not specified',
        subject: json['subject'] as String,
        teacher: json['teacher'] as String,
      );
}

class ExamRecord {
  ExamRecord({
    required this.id,
    required this.name,
    required this.startDate,
    required this.totalMarks,
  });

  final int id;
  String name;
  String startDate;
  String totalMarks;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startDate': startDate,
    'totalMarks': totalMarks,
  };

  factory ExamRecord.fromJson(Map<String, dynamic> json) => ExamRecord(
    id: json['id'] as int,
    name: json['name'] as String,
    startDate: json['startDate'] as String,
    totalMarks: json['totalMarks'] as String,
  );
}

class MarksRecord {
  MarksRecord({
    required this.id,
    required this.studentName,
    required this.examName,
    required this.subject,
    required this.marks,
    required this.totalMarks,
    required this.grade,
  });

  final int id;
  String studentName;
  String examName;
  String subject;
  String marks;
  String totalMarks;
  String grade;

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentName': studentName,
    'examName': examName,
    'subject': subject,
    'marks': marks,
    'totalMarks': totalMarks,
    'grade': grade,
  };

  factory MarksRecord.fromJson(Map<String, dynamic> json) => MarksRecord(
    id: json['id'] as int,
    studentName: json['studentName'] as String,
    examName: json['examName'] as String? ?? 'General Assessment',
    subject: json['subject'] as String,
    marks: json['marks'] as String,
    totalMarks: json['totalMarks'] as String,
    grade: json['grade'] as String,
  );
}

class ReportCard {
  ReportCard({
    required this.id,
    required this.studentName,
    required this.className,
    required this.semester,
  });

  final int id;
  String studentName;
  String className;
  String semester;

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentName': studentName,
    'className': className,
    'semester': semester,
  };

  factory ReportCard.fromJson(Map<String, dynamic> json) => ReportCard(
    id: json['id'] as int,
    studentName: json['studentName'] as String,
    className: json['className'] as String,
    semester: json['semester'] as String,
  );
}
