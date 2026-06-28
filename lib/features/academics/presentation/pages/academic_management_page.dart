import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';
import 'package:flutter/material.dart';

class AcademicManagementPage extends StatefulWidget {
  const AcademicManagementPage({super.key});

  @override
  State<AcademicManagementPage> createState() => _AcademicManagementPageState();
}

class _AcademicManagementPageState extends PersistentModuleState<AcademicManagementPage> {
  final List<ClassRecord> _classes = [
    ClassRecord(id: 1, name: 'Class 8', section: 'A', classTeacher: 'Priya Singh', capacity: 40),
    ClassRecord(id: 2, name: 'Class 9', section: 'B', classTeacher: 'Ramesh Kumar', capacity: 42),
  ];

  final List<SectionRecord> _sections = [];
  final List<SubjectRecord> _subjects = [];
  final List<TimetableRecord> _timetables = [];
  final List<ExamRecord> _exams = [];
  final List<MarksRecord> _marks = [];
  final List<ReportCard> _reportCards = [];

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
    _classes..clear()..addAll((data['classes'] as List? ?? []).map((e) => ClassRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    _sections..clear()..addAll((data['sections'] as List? ?? []).map((e) => SectionRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    _subjects..clear()..addAll((data['subjects'] as List? ?? []).map((e) => SubjectRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    _timetables..clear()..addAll((data['timetables'] as List? ?? []).map((e) => TimetableRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    _exams..clear()..addAll((data['exams'] as List? ?? []).map((e) => ExamRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    _marks..clear()..addAll((data['marks'] as List? ?? []).map((e) => MarksRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    _reportCards..clear()..addAll((data['reportCards'] as List? ?? []).map((e) => ReportCard.fromJson(Map<String, dynamic>.from(e as Map))));
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

  Widget _buildSectionHeader(String title, String subtitle, {VoidCallback? action, String? actionLabel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (action != null && actionLabel != null)
            ElevatedButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  Widget _buildClassesTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Class Management', 'Create and manage classes.', action: () => _showClassDialog(context), actionLabel: 'New Class'),
        Expanded(
          child: _classes.isEmpty
              ? const Center(child: Text('No classes created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _classes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cls = _classes[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('${cls.name} - ${cls.section}'),
                        subtitle: Text('Teacher: ${cls.classTeacher} • Capacity: ${cls.capacity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showClassDialog(context, classRecord: cls)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete class?',
                                  message: 'This will remove ${cls.name} - ${cls.section} from classes.',
                                );
                                if (!confirmed) return;
                                setState(() => _classes.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSectionsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Section Management', 'Create sections and assign class teachers.', action: () => _showSectionDialog(context), actionLabel: 'New Section'),
        Expanded(
          child: _sections.isEmpty
              ? const Center(child: Text('No sections created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final section = _sections[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(section.name),
                        subtitle: Text('Class Teacher: ${section.classTeacher}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showSectionDialog(context, section: section)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete section?',
                              message: 'This will remove section ${section.name}.',
                            );
                            if (!confirmed) return;
                            setState(() => _sections.removeAt(index));
                              },
                            ),
                          ],
                        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Subject Management', 'Create and allocate subjects.', action: () => _showSubjectDialog(context), actionLabel: 'New Subject'),
        Expanded(
          child: _subjects.isEmpty
              ? const Center(child: Text('No subjects created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _subjects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(subject.name),
                        subtitle: Text('Code: ${subject.code} • Allocated to: ${subject.allocatedClass}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showSubjectDialog(context, subject: subject)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete subject?',
                              message: 'This will remove subject ${subject.name}.',
                            );
                            if (!confirmed) return;
                            setState(() => _subjects.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTimetablesTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Timetable Management', 'View and manage class timetables.', action: () => _showTimetableDialog(context), actionLabel: 'New Timetable'),
        Expanded(
          child: _timetables.isEmpty
              ? const Center(child: Text('No timetables created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _timetables.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final tt = _timetables[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('${tt.className} - ${tt.day}'),
                        subtitle: Text('${tt.subject} • ${tt.teacher}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showTimetableDialog(context, timetable: tt)),
                            IconButton(icon: const Icon(Icons.download), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Timetable for ${tt.className} exported.')))),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete timetable?',
                                  message: 'This will remove the ${tt.day} timetable for ${tt.className}.',
                                );
                                if (confirmed) setState(() => _timetables.removeAt(index));
                              },
                            ),
                          ],
                        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Exam Management', 'Create exams, schedules, and hall tickets.', action: () => _showExamDialog(context), actionLabel: 'New Exam'),
        Expanded(
          child: _exams.isEmpty
              ? const Center(child: Text('No exams created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _exams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final exam = _exams[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(exam.name),
                        subtitle: Text('${exam.startDate} • ${exam.totalMarks} marks'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showExamDialog(context, exam: exam)),
                            TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hall tickets for ${exam.name} generated.'))), child: const Text('Hall Ticket')),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete exam?',
                                  message: 'This will remove ${exam.name}.',
                                );
                                if (confirmed) setState(() => _exams.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMarksTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Marks Management', 'Enter marks and calculate grades.', action: () => _showMarksDialog(context), actionLabel: 'Enter Marks'),
        Expanded(
          child: _marks.isEmpty
              ? const Center(child: Text('No marks entered.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _marks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mark = _marks[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(mark.studentName),
                        subtitle: Text('${mark.subject} • Marks: ${mark.marks}/${mark.totalMarks} • Grade: ${mark.grade}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showMarksDialog(context, mark: mark)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete marks?',
                                  message: 'This will remove ${mark.subject} marks for ${mark.studentName}.',
                                );
                                if (confirmed) setState(() => _marks.removeAt(index));
                              },
                            ),
                          ],
                        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Report Cards', 'Generate and manage report cards.', action: () => _showReportCardDialog(context), actionLabel: 'Generate Report Card'),
        Expanded(
          child: _reportCards.isEmpty
              ? const Center(child: Text('No report cards available.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _reportCards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final rc = _reportCards[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(rc.studentName),
                        subtitle: Text('${rc.className} • ${rc.semester}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.download), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report card for ${rc.studentName} downloaded.')))),
                            IconButton(icon: const Icon(Icons.print), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report card for ${rc.studentName} sent to printer.')))),
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showReportCardDialog(context, reportCard: rc)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete report card?',
                                  message: 'This will remove the report card for ${rc.studentName}.',
                                );
                                if (confirmed) setState(() => _reportCards.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showClassDialog(BuildContext context, {ClassRecord? classRecord}) {
    final nameController = TextEditingController(text: classRecord?.name ?? '');
    final sectionController = TextEditingController(text: classRecord?.section ?? '');
    final teacherController = TextEditingController(text: classRecord?.classTeacher ?? '');
    final capacityController = TextEditingController(text: classRecord?.capacity.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(classRecord == null ? 'New Class' : 'Edit Class'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Class Name')),
              TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section')),
              TextField(controller: teacherController, decoration: const InputDecoration(labelText: 'Class Teacher')),
              TextField(controller: capacityController, decoration: const InputDecoration(labelText: 'Capacity')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter class name.')));
                return;
              }
              setState(() {
                if (classRecord != null) {
                  classRecord.name = name;
                  classRecord.section = sectionController.text.trim();
                  classRecord.classTeacher = teacherController.text.trim();
                  classRecord.capacity = int.tryParse(capacityController.text) ?? 40;
                } else {
                  _classes.add(ClassRecord(
                    id: _classes.isEmpty ? 1 : _classes.last.id + 1,
                    name: name,
                    section: sectionController.text.trim(),
                    classTeacher: teacherController.text.trim(),
                    capacity: int.tryParse(capacityController.text) ?? 40,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSectionDialog(BuildContext context, {SectionRecord? section}) {
    final nameController = TextEditingController(text: section?.name ?? '');
    final teacherController = TextEditingController(text: section?.classTeacher ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(section == null ? 'New Section' : 'Edit Section'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Section Name')),
              TextField(controller: teacherController, decoration: const InputDecoration(labelText: 'Class Teacher')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter section name.')));
                return;
              }
              setState(() {
                if (section == null) {
                  _sections.add(SectionRecord(
                    id: _sections.isEmpty ? 1 : _sections.last.id + 1,
                    name: name,
                    classTeacher: teacherController.text.trim(),
                  ));
                } else {
                  section
                    ..name = name
                    ..classTeacher = teacherController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(section == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showSubjectDialog(BuildContext context, {SubjectRecord? subject}) {
    final nameController = TextEditingController(text: subject?.name ?? '');
    final codeController = TextEditingController(text: subject?.code ?? '');
    String allocatedClass = subject?.allocatedClass ?? (_classes.isNotEmpty ? _classes.first.name : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(subject == null ? 'New Subject' : 'Edit Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Subject Name')),
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Subject Code')),
              DropdownButtonFormField<String>(
                initialValue: allocatedClass.isNotEmpty && _classes.any((item) => item.name == allocatedClass) ? allocatedClass : null,
                items: _classes.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                decoration: const InputDecoration(labelText: 'Allocate to Class'),
                onChanged: (value) => allocatedClass = value ?? allocatedClass,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter subject name.')));
                return;
              }
              setState(() {
                if (subject == null) {
                  _subjects.add(SubjectRecord(
                    id: _subjects.isEmpty ? 1 : _subjects.last.id + 1,
                    name: name,
                    code: codeController.text.trim(),
                    allocatedClass: allocatedClass,
                  ));
                } else {
                  subject
                    ..name = name
                    ..code = codeController.text.trim()
                    ..allocatedClass = allocatedClass;
                }
              });
              Navigator.pop(context);
            },
            child: Text(subject == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showTimetableDialog(BuildContext context, {TimetableRecord? timetable}) {
    String selectedClass = timetable?.className ?? (_classes.isNotEmpty ? _classes.first.name : '');
    String day = timetable?.day ?? 'Monday';
    final subjectController = TextEditingController(text: timetable?.subject ?? '');
    final teacherController = TextEditingController(text: timetable?.teacher ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(timetable == null ? 'Create Timetable' : 'Edit Timetable'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedClass.isNotEmpty && _classes.any((item) => item.name == selectedClass) ? selectedClass : null,
                items: _classes.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                decoration: const InputDecoration(labelText: 'Class'),
                onChanged: (value) => selectedClass = value ?? selectedClass,
              ),
              DropdownButtonFormField<String>(
                initialValue: day,
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (value) => day = value ?? day,
                decoration: const InputDecoration(labelText: 'Day'),
              ),
              TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject')),
              TextField(controller: teacherController, decoration: const InputDecoration(labelText: 'Teacher')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (selectedClass.isEmpty || subjectController.text.trim().isEmpty || teacherController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete all timetable fields.')));
                return;
              }
              setState(() {
                if (timetable == null) {
                  _timetables.add(TimetableRecord(
                    id: _timetables.isEmpty ? 1 : _timetables.last.id + 1,
                    className: selectedClass,
                    day: day,
                    subject: subjectController.text.trim(),
                    teacher: teacherController.text.trim(),
                  ));
                } else {
                  timetable
                    ..className = selectedClass
                    ..day = day
                    ..subject = subjectController.text.trim()
                    ..teacher = teacherController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(timetable == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showExamDialog(BuildContext context, {ExamRecord? exam}) {
    final nameController = TextEditingController(text: exam?.name ?? '');
    final startDateController = TextEditingController(text: exam?.startDate ?? '');
    final marksController = TextEditingController(text: exam?.totalMarks ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exam == null ? 'New Exam' : 'Edit Exam'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Exam Name')),
              TextField(controller: startDateController, decoration: const InputDecoration(labelText: 'Start Date')),
              TextField(controller: marksController, decoration: const InputDecoration(labelText: 'Total Marks')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter exam name.')));
                return;
              }
              setState(() {
                if (exam == null) {
                  _exams.add(ExamRecord(
                    id: _exams.isEmpty ? 1 : _exams.last.id + 1,
                    name: name,
                    startDate: startDateController.text.trim(),
                    totalMarks: marksController.text.trim(),
                  ));
                } else {
                  exam
                    ..name = name
                    ..startDate = startDateController.text.trim()
                    ..totalMarks = marksController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(exam == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showMarksDialog(BuildContext context, {MarksRecord? mark}) {
    final studentNameController = TextEditingController(text: mark?.studentName ?? '');
    final marksController = TextEditingController(text: mark?.marks ?? '');
    final subjectOptions = _subjects.isEmpty ? const ['N/A'] : _subjects.map((item) => item.name).toList();
    String subject = mark?.subject ?? subjectOptions.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(mark == null ? 'Enter Marks' : 'Edit Marks'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentNameController, decoration: const InputDecoration(labelText: 'Student Name')),
              DropdownButtonFormField<String>(
                initialValue: subjectOptions.contains(subject) ? subject : subjectOptions.first,
                items: subjectOptions.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                decoration: const InputDecoration(labelText: 'Subject'),
                onChanged: (value) => subject = value ?? subject,
              ),
              TextField(controller: marksController, decoration: const InputDecoration(labelText: 'Marks Obtained')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = studentNameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter student name.')));
                return;
              }
              final marks = int.tryParse(marksController.text) ?? 0;
              if (marks < 0 || marks > 100) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marks must be between 0 and 100.')));
                return;
              }
              final grade = marks >= 80 ? 'A' : marks >= 70 ? 'B' : marks >= 60 ? 'C' : 'D';
              setState(() {
                if (mark == null) {
                  _marks.add(MarksRecord(
                    id: _marks.isEmpty ? 1 : _marks.last.id + 1,
                    studentName: name,
                    subject: subject,
                    marks: marks.toString(),
                    totalMarks: '100',
                    grade: grade,
                  ));
                } else {
                  mark
                    ..studentName = name
                    ..subject = subject
                    ..marks = marks.toString()
                    ..grade = grade;
                }
              });
              Navigator.pop(context);
            },
            child: Text(mark == null ? 'Submit' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showReportCardDialog(BuildContext context, {ReportCard? reportCard}) {
    final studentController = TextEditingController(text: reportCard?.studentName ?? '');
    final classController = TextEditingController(text: reportCard?.className ?? '');
    final semesterController = TextEditingController(text: reportCard?.semester ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reportCard == null ? 'Generate Report Card' : 'Edit Report Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: studentController, decoration: const InputDecoration(labelText: 'Student Name')),
            TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class')),
            TextField(controller: semesterController, decoration: const InputDecoration(labelText: 'Semester')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (studentController.text.trim().isEmpty || classController.text.trim().isEmpty || semesterController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete all report card fields.')));
                return;
              }
              setState(() {
                if (reportCard == null) {
                  _reportCards.add(ReportCard(
                    id: _reportCards.isEmpty ? 1 : _reportCards.last.id + 1,
                    studentName: studentController.text.trim(),
                    className: classController.text.trim(),
                    semester: semesterController.text.trim(),
                  ));
                } else {
                  reportCard
                    ..studentName = studentController.text.trim()
                    ..className = classController.text.trim()
                    ..semester = semesterController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(reportCard == null ? 'Generate' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class ClassRecord {
  ClassRecord({required this.id, required this.name, required this.section, required this.classTeacher, required this.capacity});
  final int id;
  String name;
  String section;
  String classTeacher;
  int capacity;
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'section': section, 'classTeacher': classTeacher, 'capacity': capacity};
  factory ClassRecord.fromJson(Map<String, dynamic> j) => ClassRecord(id: j['id'] as int, name: j['name'] as String, section: j['section'] as String, classTeacher: j['classTeacher'] as String, capacity: j['capacity'] as int);
}

class SectionRecord {
  SectionRecord({required this.id, required this.name, required this.classTeacher});
  final int id;
  String name;
  String classTeacher;
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'classTeacher': classTeacher};
  factory SectionRecord.fromJson(Map<String, dynamic> j) => SectionRecord(id: j['id'] as int, name: j['name'] as String, classTeacher: j['classTeacher'] as String);
}

class SubjectRecord {
  SubjectRecord({required this.id, required this.name, required this.code, required this.allocatedClass});
  final int id;
  String name;
  String code;
  String allocatedClass;
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code, 'allocatedClass': allocatedClass};
  factory SubjectRecord.fromJson(Map<String, dynamic> j) => SubjectRecord(id: j['id'] as int, name: j['name'] as String, code: j['code'] as String, allocatedClass: j['allocatedClass'] as String);
}

class TimetableRecord {
  TimetableRecord({required this.id, required this.className, required this.day, required this.subject, required this.teacher});
  final int id;
  String className;
  String day;
  String subject;
  String teacher;
  Map<String, dynamic> toJson() => {'id': id, 'className': className, 'day': day, 'subject': subject, 'teacher': teacher};
  factory TimetableRecord.fromJson(Map<String, dynamic> j) => TimetableRecord(id: j['id'] as int, className: j['className'] as String, day: j['day'] as String, subject: j['subject'] as String, teacher: j['teacher'] as String);
}

class ExamRecord {
  ExamRecord({required this.id, required this.name, required this.startDate, required this.totalMarks});
  final int id;
  String name;
  String startDate;
  String totalMarks;
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'startDate': startDate, 'totalMarks': totalMarks};
  factory ExamRecord.fromJson(Map<String, dynamic> j) => ExamRecord(id: j['id'] as int, name: j['name'] as String, startDate: j['startDate'] as String, totalMarks: j['totalMarks'] as String);
}

class MarksRecord {
  MarksRecord({required this.id, required this.studentName, required this.subject, required this.marks, required this.totalMarks, required this.grade});
  final int id;
  String studentName;
  String subject;
  String marks;
  final String totalMarks;
  String grade;
  Map<String, dynamic> toJson() => {'id': id, 'studentName': studentName, 'subject': subject, 'marks': marks, 'totalMarks': totalMarks, 'grade': grade};
  factory MarksRecord.fromJson(Map<String, dynamic> j) => MarksRecord(id: j['id'] as int, studentName: j['studentName'] as String, subject: j['subject'] as String, marks: j['marks'] as String, totalMarks: j['totalMarks'] as String, grade: j['grade'] as String);
}

class ReportCard {
  ReportCard({required this.id, required this.studentName, required this.className, required this.semester});
  final int id;
  String studentName;
  String className;
  String semester;
  Map<String, dynamic> toJson() => {'id': id, 'studentName': studentName, 'className': className, 'semester': semester};
  factory ReportCard.fromJson(Map<String, dynamic> j) => ReportCard(id: j['id'] as int, studentName: j['studentName'] as String, className: j['className'] as String, semester: j['semester'] as String);
}
