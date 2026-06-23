import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class AcademicManagementPage extends StatefulWidget {
  const AcademicManagementPage({super.key});

  @override
  State<AcademicManagementPage> createState() => _AcademicManagementPageState();
}

class _AcademicManagementPageState extends State<AcademicManagementPage> {
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
                        trailing: IconButton(
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
                        trailing: IconButton(
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
                        trailing: IconButton(icon: const Icon(Icons.download), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Timetable for ${tt.className} exported.')))),
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
                        trailing: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hall tickets for ${exam.name} generated.'))), child: const Text('Hall Ticket')),
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
                        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit marks for ${mark.studentName}.')))),
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
        _buildSectionHeader('Report Cards', 'Generate and download report cards.'),
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

  void _showSectionDialog(BuildContext context) {
    final nameController = TextEditingController();
    final teacherController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Section'),
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
                _sections.add(SectionRecord(
                  id: _sections.isEmpty ? 1 : _sections.last.id + 1,
                  name: name,
                  classTeacher: teacherController.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSubjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    String allocatedClass = _classes.isNotEmpty ? _classes.first.name : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Subject Name')),
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Subject Code')),
              DropdownButtonFormField<String>(
                value: allocatedClass.isNotEmpty ? allocatedClass : null,
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
                _subjects.add(SubjectRecord(
                  id: _subjects.isEmpty ? 1 : _subjects.last.id + 1,
                  name: name,
                  code: codeController.text.trim(),
                  allocatedClass: allocatedClass,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showTimetableDialog(BuildContext context) {
    String selectedClass = _classes.isNotEmpty ? _classes.first.name : '';
    String day = 'Monday';
    final subjectController = TextEditingController();
    final teacherController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Timetable'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedClass.isNotEmpty ? selectedClass : null,
                items: _classes.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                decoration: const InputDecoration(labelText: 'Class'),
                onChanged: (value) => selectedClass = value ?? selectedClass,
              ),
              DropdownButtonFormField<String>(
                value: day,
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
              setState(() {
                _timetables.add(TimetableRecord(
                  id: _timetables.isEmpty ? 1 : _timetables.last.id + 1,
                  className: selectedClass,
                  day: day,
                  subject: subjectController.text.trim(),
                  teacher: teacherController.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showExamDialog(BuildContext context) {
    final nameController = TextEditingController();
    final startDateController = TextEditingController();
    final marksController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Exam'),
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
                _exams.add(ExamRecord(
                  id: _exams.isEmpty ? 1 : _exams.last.id + 1,
                  name: name,
                  startDate: startDateController.text.trim(),
                  totalMarks: marksController.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showMarksDialog(BuildContext context) {
    final studentNameController = TextEditingController();
    final marksController = TextEditingController();
    String subject = _subjects.isNotEmpty ? _subjects.first.name : 'N/A';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Marks'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentNameController, decoration: const InputDecoration(labelText: 'Student Name')),
              DropdownButtonFormField<String>(
                value: subject.isNotEmpty ? subject : null,
                items: _subjects.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
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
              final grade = marks >= 80 ? 'A' : marks >= 70 ? 'B' : marks >= 60 ? 'C' : 'D';
              setState(() {
                _marks.add(MarksRecord(
                  id: _marks.isEmpty ? 1 : _marks.last.id + 1,
                  studentName: name,
                  subject: subject,
                  marks: marks.toString(),
                  totalMarks: '100',
                  grade: grade,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Submit'),
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
}

class SectionRecord {
  SectionRecord({required this.id, required this.name, required this.classTeacher});
  final int id;
  final String name;
  final String classTeacher;
}

class SubjectRecord {
  SubjectRecord({required this.id, required this.name, required this.code, required this.allocatedClass});
  final int id;
  final String name;
  final String code;
  final String allocatedClass;
}

class TimetableRecord {
  TimetableRecord({required this.id, required this.className, required this.day, required this.subject, required this.teacher});
  final int id;
  final String className;
  final String day;
  final String subject;
  final String teacher;
}

class ExamRecord {
  ExamRecord({required this.id, required this.name, required this.startDate, required this.totalMarks});
  final int id;
  final String name;
  final String startDate;
  final String totalMarks;
}

class MarksRecord {
  MarksRecord({required this.id, required this.studentName, required this.subject, required this.marks, required this.totalMarks, required this.grade});
  final int id;
  final String studentName;
  final String subject;
  final String marks;
  final String totalMarks;
  final String grade;
}

class ReportCard {
  ReportCard({required this.id, required this.studentName, required this.className, required this.semester});
  final int id;
  final String studentName;
  final String className;
  final String semester;
}
