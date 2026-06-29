import 'dart:convert';

import 'package:educare/core/utils/browser_download.dart';
import 'package:educare/core/widgets/delete_confirmation_dialog.dart';
import 'package:educare/core/widgets/persistent_module_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({super.key});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends PersistentModuleState<StudentManagementPage> {
  static const String _admissionBrandPrefix = 'edu';
  static const _genders = ['Male', 'Female', 'Other'];
  static const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  static const _defaultCategories = ['Others', 'General', 'OBC', 'SC', 'ST'];
  static const _sections = ['A', 'B', 'C', 'D'];
  static const _classes = [
    'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6',
    'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12',
  ];

  final List<StudentRecord> _students = [
    StudentRecord(
      admissionNo: 'edu20261',
      name: 'Aarav Sharma',
      gender: 'Male',
      dob: '2010-05-15',
      bloodGroup: 'O+',
      address: 'Bangalore, Karnataka',
      mobileNumber: '9876543210',
      aadhaarNumber: '123456789012',
      category: 'General',
      religion: 'Hindu',
      currentClass: 'Grade 8',
      section: 'A',
      fatherName: 'Rajesh Sharma',
      fatherOccupation: 'Software Engineer',
      fatherPhone: '9876543200',
      motherName: 'Neha Sharma',
      motherOccupation: 'Teacher',
      motherPhone: '9876543211',
    ),
    StudentRecord(
      admissionNo: 'edu20262',
      name: 'Priya Patel',
      gender: 'Female',
      dob: '2010-08-22',
      bloodGroup: 'A+',
      address: 'Pune, Maharashtra',
      mobileNumber: '9123456789',
      aadhaarNumber: '123456789013',
      category: 'OBC',
      religion: 'Hindu',
      currentClass: 'Grade 9',
      section: 'B',
      fatherName: 'Vikram Patel',
      fatherOccupation: 'Business Owner',
      fatherPhone: '9123456780',
      motherName: 'Kavita Patel',
      motherOccupation: 'Doctor',
      motherPhone: '9123456781',
    ),
  ];

  final List<StudentDocument> _documents = [];
  final List<StudentPromotion> _promotions = [];
  final List<AlumniRecord> _alumni = [];
  final Map<String, String> _studentPhotos = {};
  final Set<String> _generatedCertificates = {};
  final GlobalKey _registrationContentKey = GlobalKey();
  final GlobalKey _profilesContentKey = GlobalKey();
  final GlobalKey _documentsContentKey = GlobalKey();
  final TextEditingController _profileSearchController = TextEditingController();
  final TextEditingController _documentSearchController = TextEditingController();
  final TextEditingController _photoSearchController = TextEditingController();
  final TextEditingController _parentSearchController = TextEditingController();
  final TextEditingController _promotionSearchController = TextEditingController();
  final TextEditingController _transferSearchController = TextEditingController();
  final TextEditingController _alumniSearchController = TextEditingController();
  final Set<String> _categoryOptions = {..._defaultCategories};
  String _profileSearchQuery = '';
  String _documentSearchQuery = '';
  String _photoSearchQuery = '';
  String _parentSearchQuery = '';
  String _promotionSearchQuery = '';
  String _transferSearchQuery = '';
  String _alumniSearchQuery = '';

  @override
  String get moduleKey => 'students';

  @override
  Map<String, dynamic> exportState() => {
        'students': _students.map((item) => item.toJson()).toList(),
        'documents': _documents.map((item) => item.toJson()).toList(),
        'promotions': _promotions.map((item) => item.toJson()).toList(),
        'alumni': _alumni.map((item) => item.toJson()).toList(),
        'photos': _studentPhotos,
        'certificates': _generatedCertificates.toList(),
      };

  @override
  void importState(Map<String, dynamic> data) {
    _students
      ..clear()
      ..addAll((data['students'] as List? ?? []).map((item) => StudentRecord.fromJson(Map<String, dynamic>.from(item as Map))));
    _documents
      ..clear()
      ..addAll((data['documents'] as List? ?? []).map((item) => StudentDocument.fromJson(Map<String, dynamic>.from(item as Map))));
    _promotions
      ..clear()
      ..addAll((data['promotions'] as List? ?? []).map((item) => StudentPromotion.fromJson(Map<String, dynamic>.from(item as Map))));
    _alumni
      ..clear()
      ..addAll((data['alumni'] as List? ?? []).map((item) => AlumniRecord.fromJson(Map<String, dynamic>.from(item as Map))));
    _studentPhotos
      ..clear()
      ..addAll(Map<String, String>.from(data['photos'] as Map? ?? {}));
    _generatedCertificates
      ..clear()
      ..addAll(List<String>.from(data['certificates'] as List? ?? []));
    _syncCategoryOptions();
  }

  @override
  void dispose() {
    _profileSearchController.dispose();
    _documentSearchController.dispose();
    _photoSearchController.dispose();
    _parentSearchController.dispose();
    _promotionSearchController.dispose();
    _transferSearchController.dispose();
    _alumniSearchController.dispose();
    super.dispose();
  }

  String _generateAdmissionNo() {
    final currentYear = DateTime.now().year;
    var sequence = _students.length + 1;
    var candidate = '$_admissionBrandPrefix$currentYear$sequence';
    while (_students.any((student) => student.admissionNo == candidate)) {
      sequence++;
      candidate = '$_admissionBrandPrefix$currentYear$sequence';
    }
    return candidate;
  }

  void _removeStudent(StudentRecord student) {
    setState(() {
      _students.remove(student);
      _documents.removeWhere((item) => item.studentAdmissionNo == student.admissionNo);
      _promotions.removeWhere((item) => item.studentAdmissionNo == student.admissionNo);
      _studentPhotos.remove(student.admissionNo);
      _generatedCertificates.remove(student.admissionNo);
    });
  }

  void _syncCategoryOptions() {
    _categoryOptions
      ..clear()
      ..addAll(_defaultCategories)
      ..addAll(
        _students.map((student) => student.category.trim()).where((category) => category.isNotEmpty),
      );
  }

  bool _matchesStudentQuery(StudentRecord student, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return true;
    return student.name.toLowerCase().contains(normalizedQuery) ||
        student.admissionNo.toLowerCase().contains(normalizedQuery);
  }

  List<StudentRecord> _filterStudents(String query) {
    return _students.where((student) => _matchesStudentQuery(student, query)).toList();
  }

  bool _matchesDocumentQuery(StudentDocument document, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return true;
    return document.studentName.toLowerCase().contains(normalizedQuery) ||
        document.studentAdmissionNo.toLowerCase().contains(normalizedQuery);
  }

  Future<void> _downloadDocument(BuildContext context, StudentDocument document) async {
    final encodedBytes = document.fileData;
    if (encodedBytes == null || encodedBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Original file data is unavailable for ${document.fileName}.')),
      );
      return;
    }

    final didDownload = await triggerBrowserDownload(
      fileName: document.fileName,
      base64Data: encodedBytes,
    );

    if (!didDownload) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document download is currently available in the web build only.')),
      );
      return;
    }
  }

  Widget _buildCompactSearchField({
    required Key fieldKey,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 280,
      child: TextField(
        key: fieldKey,
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search by name or admission no',
          prefixIcon: const Icon(Icons.search, size: 18),
          prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchableSectionHeader(
    String title,
    String subtitle, {
    required Key fieldKey,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    VoidCallback? action,
    String? actionLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final searchField = _buildCompactSearchField(
            fieldKey: fieldKey,
            controller: controller,
            onChanged: onChanged,
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 16),
                searchField,
                if (action != null && actionLabel != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: action, child: Text(actionLabel)),
                ],
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              searchField,
              if (action != null && actionLabel != null) ...[
                const SizedBox(height: 12),
                ElevatedButton(onPressed: action, child: Text(actionLabel)),
              ],
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Registration'),
              Tab(text: 'Profiles'),
              Tab(text: 'Documents'),
              Tab(text: 'Photos'),
              Tab(text: 'Parent Info'),
              Tab(text: 'Promotion'),
              Tab(text: 'Transfer Cert'),
              Tab(text: 'Alumni'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRegistrationTab(context),
            _buildProfilesTab(context),
            _buildDocumentsTab(context),
            _buildPhotosTab(context),
            _buildParentInfoTab(context),
            _buildPromotionTab(context),
            _buildTransferCertTab(context),
            _buildAlumniTab(context),
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

  Widget _buildRegistrationTab(BuildContext context) {
    return Container(
      key: _registrationContentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Student Registration',
            'Add new students or edit existing registrations.',
            action: () => _showStudentDialog(context, anchorKey: _registrationContentKey),
            actionLabel: 'New Admission',
          ),
          Expanded(
            child: _students.isEmpty
                ? const Center(child: Text('No students registered yet.'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _students.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text('${student.name} (${student.admissionNo})'),
                          subtitle: Text('${student.currentClass}-${student.section} • ${student.gender} • DOB: ${student.dob}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showStudentDialog(
                                  context,
                                  student: student,
                                  anchorKey: _registrationContentKey,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirmed = await showDeleteConfirmationDialog(
                                    context,
                                    title: 'Delete student?',
                                    message: 'This will remove ${student.name} from student registrations.',
                                  );
                                  if (!confirmed) return;
                                  _removeStudent(student);
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
      ),
    );
  }

  Widget _buildProfilesTab(BuildContext context) {
    final filteredStudents = _filterStudents(_profileSearchQuery);
    return Column(
      key: _profilesContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchableSectionHeader(
          'Student Profiles',
          'View, edit, or delete individual student records.',
          fieldKey: const Key('student_profile_search_field'),
          controller: _profileSearchController,
          onChanged: (value) => setState(() => _profileSearchQuery = value),
        ),
        Expanded(
          child: filteredStudents.isEmpty
              ? const Center(child: Text('No student profiles available.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        title: Text(student.name),
                        subtitle: Text(student.admissionNo),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 4,
                                  children: [
                                _buildProfileField('Gender', student.gender),
                                _buildProfileField('DOB', student.dob),
                                _buildProfileField('Blood Group', student.bloodGroup),
                                _buildProfileField('Address', student.address),
                                _buildProfileField('Mobile', student.mobileNumber),
                                _buildProfileField('Aadhaar', student.aadhaarNumber),
                                _buildProfileField('Category', student.category),
                                _buildProfileField('Religion', student.religion),
                                _buildProfileField('Class-Section', '${student.currentClass}-${student.section}'),
                                  ],
                                ),
                                const Divider(),
                                Wrap(
                                  alignment: WrapAlignment.end,
                                  spacing: 8,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => _showStudentDialog(context, student: student, anchorKey: _profilesContentKey),
                                      icon: const Icon(Icons.edit_outlined),
                                      label: const Text('Edit'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async {
                                        final confirmed = await showDeleteConfirmationDialog(
                                          context,
                                          title: 'Delete student?',
                                          message: 'This will remove ${student.name} and their profile.',
                                        );
                                        if (confirmed) _removeStudent(student);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDocumentsTab(BuildContext context) {
    final filteredDocuments = _documents.where((document) => _matchesDocumentQuery(document, _documentSearchQuery)).toList();
    return Column(
      key: _documentsContentKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final searchField = _buildCompactSearchField(
                fieldKey: const Key('student_document_search_field'),
                controller: _documentSearchController,
                onChanged: (value) => setState(() => _documentSearchQuery = value),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Student Documents', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Upload and manage student documents.', style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        searchField,
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _showDocumentDialog(context),
                          child: const Text('Upload Document'),
                        ),
                      ],
                    )
                  else ...[
                    const Text('Student Documents', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Upload and manage student documents.', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),
                    searchField,
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showDocumentDialog(context),
                      child: const Text('Upload Document'),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        Expanded(
          child: filteredDocuments.isEmpty
              ? const Center(child: Text('No documents uploaded yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDocuments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = filteredDocuments[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(doc.fileName),
                        subtitle: Text('${doc.studentName} • ${doc.documentType}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Download document',
                              icon: const Icon(Icons.download_outlined),
                              onPressed: () => _downloadDocument(context, doc),
                            ),
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showDocumentDialog(context, document: doc)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete document?',
                              message: 'This will remove ${doc.fileName} from student documents.',
                            );
                            if (!confirmed) return;
                            setState(() => _documents.remove(doc));
                            await persistNow();
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

  Widget _buildPhotosTab(BuildContext context) {
    final filteredStudents = _filterStudents(_photoSearchQuery);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchableSectionHeader(
          'Student Photos',
          'Upload student profile photos.',
          fieldKey: const Key('student_photo_search_field'),
          controller: _photoSearchController,
          onChanged: (value) => setState(() => _photoSearchQuery = value),
          action: () => _showPhotoDialog(context),
          actionLabel: 'Upload Photo',
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxColumns = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 780
                      ? 3
                      : constraints.maxWidth >= 520
                          ? 2
                          : 1;
              final effectiveColumns = filteredStudents.isEmpty
                  ? maxColumns
                  : filteredStudents.length < maxColumns
                      ? filteredStudents.length
                      : maxColumns;

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: effectiveColumns == 0 ? 1 : effectiveColumns,
                  childAspectRatio: effectiveColumns <= 1 ? 1.6 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _studentPhotos.containsKey(student.admissionNo) ? Icons.account_circle : Icons.person_outline,
                            size: 48,
                            color: _studentPhotos.containsKey(student.admissionNo) ? Theme.of(context).colorScheme.primary : null,
                          ),
                          const SizedBox(height: 8),
                          Text(student.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                          if (_studentPhotos.containsKey(student.admissionNo))
                            Text(
                              _studentPhotos[student.admissionNo]!,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _showPhotoDialog(context, student: student)),
                              if (_studentPhotos.containsKey(student.admissionNo))
                                IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => _studentPhotos.remove(student.admissionNo))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParentInfoTab(BuildContext context) {
    final filteredStudents = _filterStudents(_parentSearchQuery);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchableSectionHeader(
          'Parent Details',
          'Manage parent and guardian information.',
          fieldKey: const Key('student_parent_search_field'),
          controller: _parentSearchController,
          onChanged: (value) => setState(() => _parentSearchQuery = value),
          action: () => _showParentDialog(context),
          actionLabel: 'Add Parent',
        ),
        Expanded(
          child: filteredStudents.isEmpty
              ? const Center(child: Text('No parent information available.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(student.name),
                        subtitle: Text(
                          'Father: ${student.fatherName} (${student.fatherPhone})\n'
                          'Mother: ${student.motherName} (${student.motherPhone})',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit parent details',
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showParentDialog(context, student: student),
                            ),
                            IconButton(
                              tooltip: 'Clear parent details',
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmed = await showDeleteConfirmationDialog(
                                  context,
                                  title: 'Delete parent details?',
                                  message: 'This will clear parent details for ${student.name}.',
                                );
                                if (!confirmed) return;
                                setState(() {
                                  student
                                    ..fatherName = ''
                                    ..fatherOccupation = ''
                                    ..fatherPhone = ''
                                    ..motherName = ''
                                    ..motherOccupation = ''
                                    ..motherPhone = '';
                                });
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

  Widget _buildPromotionTab(BuildContext context) {
    final filteredPromotions = _promotions.where((promotion) {
      final normalizedQuery = _promotionSearchQuery.trim().toLowerCase();
      if (normalizedQuery.isEmpty) return true;
      return promotion.studentName.toLowerCase().contains(normalizedQuery) ||
          promotion.studentAdmissionNo.toLowerCase().contains(normalizedQuery);
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchableSectionHeader(
          'Student Promotion',
          'Manage promotion and class upgrades.',
          fieldKey: const Key('student_promotion_search_field'),
          controller: _promotionSearchController,
          onChanged: (value) => setState(() => _promotionSearchQuery = value),
          action: () => _showPromotionDialog(context),
          actionLabel: 'Promote Student',
        ),
        Expanded(
          child: filteredPromotions.isEmpty
              ? const Center(child: Text('No promotions recorded yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPromotions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final promotion = filteredPromotions[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(promotion.studentName),
                        subtitle: Text('${promotion.fromClass} → ${promotion.toClass} • ${promotion.promotionDate}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showPromotionDialog(context, promotion: promotion)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete promotion record?',
                              message: 'This will remove the promotion record for ${promotion.studentName}.',
                            );
                            if (!confirmed) return;
                            setState(() => _promotions.remove(promotion));
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

  Widget _buildTransferCertTab(BuildContext context) {
    final filteredStudents = _filterStudents(_transferSearchQuery);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchableSectionHeader(
          'Transfer Certificates',
          'Generated certificates remain available here for viewing.',
          fieldKey: const Key('student_transfer_search_field'),
          controller: _transferSearchController,
          onChanged: (value) => setState(() => _transferSearchQuery = value),
        ),
        Expanded(
          child: filteredStudents.isEmpty
              ? const Center(child: Text('No students available for transfer certificates.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredStudents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(student.name),
                        subtitle: Text('${student.admissionNo} • ${student.currentClass}-${student.section}'),
                        leading: Icon(
                          _generatedCertificates.contains(student.admissionNo)
                              ? Icons.verified_outlined
                              : Icons.description_outlined,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_generatedCertificates.contains(student.admissionNo)) {
                                  _showTransferCertificate(context, student);
                                  return;
                                }
                                setState(() => _generatedCertificates.add(student.admissionNo));
                                _showTransferCertificate(context, student);
                              },
                              child: Text(_generatedCertificates.contains(student.admissionNo) ? 'View' : 'Transfer'),
                            ),
                            if (_generatedCertificates.contains(student.admissionNo))
                              IconButton(
                                tooltip: 'Revoke certificate',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => setState(() => _generatedCertificates.remove(student.admissionNo)),
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

  Widget _buildAlumniTab(BuildContext context) {
    final filteredAlumni = _alumni.where((alumni) {
      final normalizedQuery = _alumniSearchQuery.trim().toLowerCase();
      if (normalizedQuery.isEmpty) return true;
      return alumni.name.toLowerCase().contains(normalizedQuery) ||
          alumni.graduationYear.toLowerCase().contains(normalizedQuery);
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchableSectionHeader(
          'Alumni Management',
          'Track and manage alumni records.',
          fieldKey: const Key('student_alumni_search_field'),
          controller: _alumniSearchController,
          onChanged: (value) => setState(() => _alumniSearchQuery = value),
          action: () => _showAlumniDialog(context),
          actionLabel: 'Add Alumni',
        ),
        Expanded(
          child: filteredAlumni.isEmpty
              ? const Center(child: Text('No alumni records yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredAlumni.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final alum = filteredAlumni[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(alum.name),
                        subtitle: Text('Batch ${alum.graduationYear} • ${alum.profession}'),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              tooltip: 'Edit alumni',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _showAlumniDialog(context, alumni: alum),
                            ),
                            IconButton(
                              tooltip: 'Delete alumni',
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                            final confirmed = await showDeleteConfirmationDialog(
                              context,
                              title: 'Delete alumni record?',
                              message: 'This will remove ${alum.name} from alumni records.',
                            );
                            if (!confirmed) return;
                            setState(() => _alumni.remove(alum));
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

  Widget _buildProfileField(String label, String value) {
    return SizedBox(
      width: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
          ),
          Expanded(child: Text(value.isEmpty ? '—' : value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  void _showStudentDialog(BuildContext context, {StudentRecord? student, GlobalKey? anchorKey}) {
    final renderObject = anchorKey?.currentContext?.findRenderObject() ?? context.findRenderObject();
    final contentRect = renderObject is RenderBox
        ? renderObject.localToGlobal(Offset.zero) & renderObject.size
      : Offset.zero & MediaQuery.sizeOf(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: student?.name ?? '');
    final generatedAdmissionNo = student?.admissionNo ?? _generateAdmissionNo();
    final admissionNoController = TextEditingController(text: generatedAdmissionNo);
    final dobController = TextEditingController(text: student?.dob ?? '');
    final addressController = TextEditingController(text: student?.address ?? '');
    final mobileController = TextEditingController(text: student?.mobileNumber ?? '');
    final aadhaarController = TextEditingController(text: student?.aadhaarNumber ?? '');
    final categoryController = TextEditingController(text: student?.category.isNotEmpty == true ? student!.category : 'Others');
    final religionController = TextEditingController(text: student?.religion ?? '');
    String? gender = _genders.contains(student?.gender) ? student!.gender : null;
    String? bloodGroup = _bloodGroups.contains(student?.bloodGroup) ? student!.bloodGroup : null;
    String? currentClass = _classes.contains(student?.currentClass) ? student!.currentClass : null;
    String? section = _sections.contains(student?.section) ? student!.section : null;

    Future<void> submit(BuildContext drawerContext) async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final normalizedCategory = categoryController.text.trim().isEmpty ? 'Others' : categoryController.text.trim();
      setState(() {
        final record = student ??
            StudentRecord(
              admissionNo: generatedAdmissionNo.trim(),
              name: '',
              gender: '',
              dob: '',
              bloodGroup: '',
              address: '',
              mobileNumber: '',
              aadhaarNumber: '',
              category: '',
              religion: '',
              currentClass: '',
              section: '',
              fatherName: '',
              fatherOccupation: '',
              fatherPhone: '',
              motherName: '',
              motherOccupation: '',
              motherPhone: '',
            );
        record
          ..name = nameController.text.trim()
          ..gender = gender!
          ..dob = dobController.text
          ..bloodGroup = bloodGroup ?? ''
          ..address = addressController.text.trim()
          ..mobileNumber = mobileController.text
          ..aadhaarNumber = aadhaarController.text
          ..category = normalizedCategory
          ..religion = religionController.text.trim()
          ..currentClass = currentClass!
          ..section = section!;
        if (student == null) _students.add(record);
        _categoryOptions.add(normalizedCategory);
      });
      await persistNow();
      Navigator.pop(drawerContext);
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close admission form',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, animation, secondaryAnimation, child) => child,
      pageBuilder: (dialogContext, animation, secondaryAnimation) => StatefulBuilder(
        builder: (context, setDialogState) {
          final availableWidth = contentRect.width;
          final drawerWidth = availableWidth < 900 ? availableWidth : availableWidth * 0.52;
          final panelAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return Stack(
            children: [
              Positioned(
                left: contentRect.left,
                top: contentRect.top,
                width: drawerWidth,
                height: contentRect.height,
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: panelAnimation,
                    builder: (context, child) => Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: panelAnimation.value,
                      child: child,
                    ),
                    child: Material(
                      key: const Key('admission_side_drawer'),
                      elevation: 24,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(student == null ? 'New Admission' : 'Edit Student'),
              actions: [
                IconButton(
                  tooltip: 'Close',
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ],
            ),
            body: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          _formField(
                            controller: admissionNoController,
                            label: 'Admission Number',
                            readOnly: true,
                          ),
                          _formField(
                            controller: nameController,
                            label: 'Student Name',
                            validator: _required('student name'),
                          ),
                          _dropdownField(
                            label: 'Gender',
                            value: gender,
                            items: _genders,
                            onChanged: (value) => setDialogState(() => gender = value),
                          ),
                          _formField(
                            controller: dobController,
                            label: 'Date of Birth',
                            readOnly: true,
                            suffixIcon: const Icon(Icons.calendar_today_outlined),
                            validator: _required('date of birth'),
                            onTap: () async {
                              final selected = await showDatePicker(
                                context: context,
                                initialDate: DateTime.tryParse(dobController.text) ?? DateTime(2010),
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                              );
                              if (selected != null) {
                                dobController.text = DateFormat('yyyy-MM-dd').format(selected);
                              }
                            },
                          ),
                          _dropdownField(
                            label: 'Blood Group',
                            value: bloodGroup,
                            items: _bloodGroups,
                            required: false,
                            onChanged: (value) => setDialogState(() => bloodGroup = value),
                          ),
                          _formField(
                            controller: mobileController,
                            label: 'Mobile Number',
                            fieldKey: const Key('admission_mobile'),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            validator: (value) => RegExp(r'^[6-9]\d{9}$').hasMatch(value ?? '')
                                ? null
                                : 'Enter a valid 10-digit mobile number',
                          ),
                          _formField(
                            controller: aadhaarController,
                            label: 'Aadhaar Number',
                            fieldKey: const Key('admission_aadhaar'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
                            validator: (value) => RegExp(r'^\d{12}$').hasMatch(value ?? '')
                                ? null
                                : 'Enter a valid 12-digit Aadhaar number',
                          ),
                          _dropdownField(
                            label: 'Class',
                            value: currentClass,
                            items: _classes,
                            onChanged: (value) => setDialogState(() => currentClass = value),
                          ),
                          _dropdownField(
                            label: 'Section',
                            value: section,
                            items: _sections,
                            onChanged: (value) => setDialogState(() => section = value),
                          ),
                          _categoryField(categoryController),
                          _formField(controller: religionController, label: 'Religion', validator: _required('religion')),
                          SizedBox(
                            width: 900,
                            child: TextFormField(
                              controller: addressController,
                              maxLines: 3,
                              decoration: const InputDecoration(labelText: 'Address', alignLabelWithHint: true),
                              validator: _required('address'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Material(
              elevation: 12,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        key: const Key('admission_cancel_button'),
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        key: const Key('admission_submit_button'),
                        onPressed: () => submit(dialogContext),
                        icon: Icon(student == null ? Icons.add : Icons.save_outlined),
                        label: Text(student == null ? 'Create' : 'Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? Function(String?) _required(String field) {
    return (value) => value == null || value.trim().isEmpty ? 'Enter $field' : null;
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    Widget? suffixIcon,
    Key? fieldKey,
  }) {
    return SizedBox(
      width: 440,
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        onTap: onTap,
        decoration: InputDecoration(labelText: label, suffixIcon: suffixIcon),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool required = true,
  }) {
    return SizedBox(
      width: 440,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: required ? (selection) => selection == null ? 'Select ${label.toLowerCase()}' : null : null,
      ),
    );
  }

  Widget _categoryField(TextEditingController controller) {
    final orderedCategories = _categoryOptions.toList()
      ..sort((left, right) {
        if (left == 'Others') return -1;
        if (right == 'Others') return 1;
        return left.compareTo(right);
      });

    return SizedBox(
      width: 440,
      child: TextFormField(
        controller: controller,
        validator: _required('category'),
        decoration: InputDecoration(
          labelText: 'Category',
          helperText: 'Type a new category or choose a saved one',
          suffixIcon: PopupMenuButton<String>(
            tooltip: 'Choose category',
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (value) => controller.text = value,
            itemBuilder: (context) => orderedCategories
                .map((category) => PopupMenuItem<String>(value: category, child: Text(category)))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showDocumentDialog(BuildContext context, {StudentDocument? document}) {
    if (_students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add a student before uploading documents.')));
      return;
    }
    String selectedAdmissionNo = document?.studentAdmissionNo ?? _students.first.admissionNo;
    String documentType = document?.documentType ?? 'Birth Certificate';
    String? selectedFileName = document?.fileName;
    String? documentFileData = document?.fileData;
    String studentSearchQuery = '';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filteredStudents = _filterStudents(studentSearchQuery);
          final studentOptions = filteredStudents.isEmpty
              ? _students.where((student) => student.admissionNo == selectedAdmissionNo).toList()
              : filteredStudents;

          return AlertDialog(
            title: Text(document == null ? 'Upload Document' : 'Edit Document'),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    key: const Key('document_student_search_field'),
                    onChanged: (value) => setDialogState(() => studentSearchQuery = value),
                    decoration: const InputDecoration(
                      labelText: 'Search student',
                      hintText: 'Search by student name or admission no',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: studentOptions.any((student) => student.admissionNo == selectedAdmissionNo)
                        ? selectedAdmissionNo
                        : (studentOptions.isNotEmpty ? studentOptions.first.admissionNo : null),
                    isExpanded: true,
                    items: studentOptions
                        .map((student) => DropdownMenuItem(
                              value: student.admissionNo,
                              child: Text('${student.name} (${student.admissionNo})'),
                            ))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Student'),
                    onChanged: (value) => selectedAdmissionNo = value ?? selectedAdmissionNo,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: documentType,
                    isExpanded: true,
                    items: const ['Birth Certificate', 'Aadhaar Card', 'Previous Mark Sheet', 'Transfer Certificate', 'Other']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Document Type'),
                    onChanged: (value) => documentType = value ?? documentType,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: Text(selectedFileName ?? 'Choose file'),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        withData: true,
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
                      );
                      if (result != null && result.files.isNotEmpty) {
                        setDialogState(() {
                          selectedFileName = result.files.single.name;
                          final bytes = result.files.single.bytes;
                          if (bytes != null && bytes.isNotEmpty) {
                            documentFileData = base64Encode(bytes);
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('PDF, PNG or JPG', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: selectedFileName == null
                  ? null
                  : () async {
                      final selectedStudent = _students.firstWhere((s) => s.admissionNo == selectedAdmissionNo);
                      setState(() {
                        if (document == null) {
                          _documents.add(StudentDocument(
                            id: _documents.isEmpty ? 1 : _documents.last.id + 1,
                            studentAdmissionNo: selectedAdmissionNo,
                            studentName: selectedStudent.name,
                            documentType: documentType,
                            fileName: selectedFileName!,
                            fileData: documentFileData,
                          ));
                        } else {
                          document
                            ..studentAdmissionNo = selectedAdmissionNo
                            ..studentName = selectedStudent.name
                            ..documentType = documentType
                            ..fileName = selectedFileName!
                            ..fileData = documentFileData;
                        }
                      });
                      await persistNow();
                      Navigator.pop(dialogContext);
                    },
              child: Text(document == null ? 'Upload' : 'Save'),
            ),
          ],
        );
        },
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, {StudentRecord? student}) {
    if (_students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add a student before uploading a photo.')));
      return;
    }
    String selectedAdmissionNo = student?.admissionNo ?? _students.first.admissionNo;
    String? selectedFileName;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Upload Student Photo'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (student == null)
                  DropdownButtonFormField<String>(
                    initialValue: selectedAdmissionNo,
                    isExpanded: true,
                    items: _students
                        .map((s) => DropdownMenuItem(value: s.admissionNo, child: Text('${s.name} (${s.admissionNo})')))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Student'),
                    onChanged: (value) => selectedAdmissionNo = value ?? selectedAdmissionNo,
                  ),
                const SizedBox(height: 16),
                const Icon(Icons.add_a_photo_outlined, size: 56),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.image_outlined),
                  label: Text(selectedFileName ?? 'Choose photo'),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(type: FileType.image);
                    if (result != null && result.files.isNotEmpty) {
                      setDialogState(() => selectedFileName = result.files.single.name);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: selectedFileName == null
                  ? null
                  : () {
                      setState(() => _studentPhotos[selectedAdmissionNo] = selectedFileName!);
                      Navigator.pop(dialogContext);
                    },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  void _showParentDialog(BuildContext context, {StudentRecord? student}) {
    if (_students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No students available for parent details.')));
      return;
    }
    final formKey = GlobalKey<FormState>();
    String selectedAdmissionNo = student?.admissionNo ?? _students.first.admissionNo;
    final fatherNameController = TextEditingController(text: student?.fatherName ?? '');
    final fatherOccupationController = TextEditingController(text: student?.fatherOccupation ?? '');
    final fatherPhoneController = TextEditingController(text: student?.fatherPhone ?? '');
    final motherNameController = TextEditingController(text: student?.motherName ?? '');
    final motherOccupationController = TextEditingController(text: student?.motherOccupation ?? '');
    final motherPhoneController = TextEditingController(text: student?.motherPhone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parent Details'),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (student == null)
                  DropdownButtonFormField<String>(
                    initialValue: selectedAdmissionNo,
                    isExpanded: true,
                    items: _students
                        .map((s) => DropdownMenuItem(value: s.admissionNo, child: Text('${s.name} (${s.admissionNo})')))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Student'),
                    onChanged: (value) => selectedAdmissionNo = value ?? selectedAdmissionNo,
                  ),
                TextFormField(
                  controller: fatherNameController,
                  decoration: const InputDecoration(labelText: 'Father Name'),
                  validator: _required('father name'),
                ),
                TextFormField(
                  controller: fatherOccupationController,
                  decoration: const InputDecoration(labelText: 'Father Occupation'),
                  validator: _required('father occupation'),
                ),
                TextFormField(
                  controller: fatherPhoneController,
                  decoration: const InputDecoration(labelText: 'Father Phone No.'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: (value) => RegExp(r'^[6-9]\d{9}$').hasMatch(value ?? '')
                      ? null
                      : 'Enter a valid 10-digit phone number',
                ),
                TextFormField(
                  controller: motherNameController,
                  decoration: const InputDecoration(labelText: 'Mother Name'),
                  validator: _required('mother name'),
                ),
                TextFormField(
                  controller: motherOccupationController,
                  decoration: const InputDecoration(labelText: 'Mother Occupation'),
                  validator: _required('mother occupation'),
                ),
                TextFormField(
                  controller: motherPhoneController,
                  decoration: const InputDecoration(labelText: 'Mother Phone No.'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: (value) => RegExp(r'^[6-9]\d{9}$').hasMatch(value ?? '')
                      ? null
                      : 'Enter a valid 10-digit phone number',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final targetStudent = student ?? _students.firstWhere((s) => s.admissionNo == selectedAdmissionNo);
              setState(() {
                targetStudent
                  ..fatherName = fatherNameController.text.trim()
                  ..fatherOccupation = fatherOccupationController.text.trim()
                  ..fatherPhone = fatherPhoneController.text.trim()
                  ..motherName = motherNameController.text.trim()
                  ..motherOccupation = motherOccupationController.text.trim()
                  ..motherPhone = motherPhoneController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPromotionDialog(BuildContext context, {StudentPromotion? promotion}) {
    if (_students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No students available to promote.')));
      return;
    }
    final formKey = GlobalKey<FormState>();
    String selectedAdmissionNo = promotion?.studentAdmissionNo ?? _students.first.admissionNo;
    String? toClass = promotion?.toClass;
    String studentSearchQuery = '';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final normalizedQuery = studentSearchQuery.trim().toLowerCase();
          final filteredStudents = _students.where((student) {
            if (normalizedQuery.isEmpty) return true;
            return student.name.toLowerCase().contains(normalizedQuery) ||
                student.admissionNo.toLowerCase().contains(normalizedQuery);
          }).toList();
          final studentOptions = filteredStudents.isEmpty
              ? _students.where((student) => student.admissionNo == selectedAdmissionNo).toList()
              : filteredStudents;

          return AlertDialog(
            title: Text(promotion == null ? 'Promote Student' : 'Edit Promotion'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    key: const Key('promotion_student_search_field'),
                    onChanged: (value) => setDialogState(() => studentSearchQuery = value),
                    decoration: const InputDecoration(
                      labelText: 'Search student',
                      hintText: 'Search by student name or admission no',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: studentOptions.any((student) => student.admissionNo == selectedAdmissionNo)
                        ? selectedAdmissionNo
                        : (studentOptions.isNotEmpty ? studentOptions.first.admissionNo : null),
                    isExpanded: true,
                    items: studentOptions
                        .map((s) => DropdownMenuItem(value: s.admissionNo, child: Text('${s.name} (${s.admissionNo})')))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Student'),
                    onChanged: promotion == null ? (value) => selectedAdmissionNo = value ?? selectedAdmissionNo : null,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: toClass,
                    isExpanded: true,
                    items: _classes.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                    decoration: const InputDecoration(labelText: 'New Class'),
                    onChanged: (value) => toClass = value,
                    validator: (value) => value == null ? 'Select the new class' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (!(formKey.currentState?.validate() ?? false)) return;
                  final studentIndex = _students.indexWhere((s) => s.admissionNo == selectedAdmissionNo);
                  final selectedStudent = studentIndex >= 0 ? _students[studentIndex] : null;
                  if (promotion == null && selectedStudent?.currentClass == toClass) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a different class.')));
                    return;
                  }
                  setState(() {
                    if (promotion == null) {
                      final promotedStudentName = selectedStudent?.name ?? '';
                      _promotions.add(StudentPromotion(
                        id: _promotions.isEmpty ? 1 : _promotions.last.id + 1,
                        studentAdmissionNo: selectedAdmissionNo,
                        studentName: promotedStudentName,
                        fromClass: selectedStudent?.currentClass ?? '',
                        toClass: toClass!,
                        promotionDate: DateTime.now().toString().split(' ').first,
                      ));
                      _promotionSearchQuery = promotedStudentName.isNotEmpty
                          ? promotedStudentName
                          : selectedAdmissionNo;
                      _promotionSearchController.text = _promotionSearchQuery;
                    } else {
                      promotion.toClass = toClass!;
                    }
                    if (selectedStudent != null) {
                      selectedStudent.currentClass = toClass!;
                    }
                  });
                  Navigator.pop(dialogContext);
                },
                child: Text(promotion == null ? 'Promote' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTransferCertificate(BuildContext context, StudentRecord student) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.school_outlined),
            SizedBox(width: 12),
            Text('Transfer Certificate'),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This certifies that ${student.name} (${student.admissionNo}) was enrolled in ${student.currentClass}, Section ${student.section}.'),
              const SizedBox(height: 16),
              Text('Date issued: ${DateFormat('dd MMM yyyy').format(DateTime.now())}'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certificate is available in the Transfer Cert tab.')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showAlumniDialog(BuildContext context, {AlumniRecord? alumni}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: alumni?.name ?? '');
    final yearController = TextEditingController(text: alumni?.graduationYear ?? '');
    final professionController = TextEditingController(text: alumni?.profession ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alumni == null ? 'Add Alumni' : 'Edit Alumni'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: _required('name'),
              ),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Graduation Year'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                validator: (value) {
                  final year = int.tryParse(value ?? '');
                  if (year == null || year < 1950 || year > DateTime.now().year) return 'Enter a valid graduation year';
                  return null;
                },
              ),
              TextFormField(
                controller: professionController,
                decoration: const InputDecoration(labelText: 'Current Profession'),
                validator: _required('current profession'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              setState(() {
                if (alumni == null) {
                  _alumni.add(AlumniRecord(
                    id: _alumni.isEmpty ? 1 : _alumni.last.id + 1,
                    name: nameController.text.trim(),
                    graduationYear: yearController.text.trim(),
                    profession: professionController.text.trim(),
                  ));
                } else {
                  alumni
                    ..name = nameController.text.trim()
                    ..graduationYear = yearController.text.trim()
                    ..profession = professionController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: Text(alumni == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class StudentRecord {
  StudentRecord({
    required this.admissionNo,
    required this.name,
    required this.gender,
    required this.dob,
    required this.bloodGroup,
    required this.address,
    required this.mobileNumber,
    required this.aadhaarNumber,
    required this.category,
    required this.religion,
    required this.currentClass,
    required this.section,
    required this.fatherName,
    required this.fatherOccupation,
    required this.fatherPhone,
    required this.motherName,
    required this.motherOccupation,
    required this.motherPhone,
  });

  final String admissionNo;
  String name;
  String gender;
  String dob;
  String bloodGroup;
  String address;
  String mobileNumber;
  String aadhaarNumber;
  String category;
  String religion;
  String currentClass;
  String section;
  String fatherName;
  String fatherOccupation;
  String fatherPhone;
  String motherName;
  String motherOccupation;
  String motherPhone;

  Map<String, dynamic> toJson() => {
        'admissionNo': admissionNo, 'name': name, 'gender': gender, 'dob': dob,
        'bloodGroup': bloodGroup, 'address': address, 'mobileNumber': mobileNumber,
        'aadhaarNumber': aadhaarNumber, 'category': category, 'religion': religion,
        'currentClass': currentClass, 'section': section,
        'fatherName': fatherName, 'fatherOccupation': fatherOccupation, 'fatherPhone': fatherPhone,
        'motherName': motherName, 'motherOccupation': motherOccupation, 'motherPhone': motherPhone,
      };

  factory StudentRecord.fromJson(Map<String, dynamic> json) => StudentRecord(
        admissionNo: json['admissionNo'] as String, name: json['name'] as String,
        gender: json['gender'] as String, dob: json['dob'] as String,
        bloodGroup: json['bloodGroup'] as String, address: json['address'] as String,
        mobileNumber: json['mobileNumber'] as String, aadhaarNumber: json['aadhaarNumber'] as String,
        category: json['category'] as String, religion: json['religion'] as String,
        currentClass: json['currentClass'] as String, section: json['section'] as String,
        fatherName: (json['fatherName'] ?? json['parentName'] ?? '') as String,
        fatherOccupation: (json['fatherOccupation'] ?? '') as String,
        fatherPhone: (json['fatherPhone'] ?? json['parentPhone'] ?? '') as String,
        motherName: (json['motherName'] ?? '') as String,
        motherOccupation: (json['motherOccupation'] ?? '') as String,
        motherPhone: (json['motherPhone'] ?? '') as String,
      );
}

class StudentDocument {
  StudentDocument({required this.id, required this.studentAdmissionNo, required this.studentName, required this.documentType, required this.fileName, this.fileData});

  final int id;
  String studentAdmissionNo;
  String studentName;
  String documentType;
  String fileName;
    String? fileData;

    Map<String, dynamic> toJson() => {'id': id, 'studentAdmissionNo': studentAdmissionNo, 'studentName': studentName, 'documentType': documentType, 'fileName': fileName, 'fileData': fileData};

  factory StudentDocument.fromJson(Map<String, dynamic> json) => StudentDocument(
        id: json['id'] as int, studentAdmissionNo: json['studentAdmissionNo'] as String,
        studentName: json['studentName'] as String, documentType: json['documentType'] as String,
      fileName: json['fileName'] as String,
      fileData: json['fileData'] as String?,
      );
}

class StudentPromotion {
  StudentPromotion({required this.id, required this.studentAdmissionNo, required this.studentName, required this.fromClass, required this.toClass, required this.promotionDate});

  final int id;
  final String studentAdmissionNo;
  final String studentName;
  final String fromClass;
  String toClass;
  final String promotionDate;

  Map<String, dynamic> toJson() => {'id': id, 'studentAdmissionNo': studentAdmissionNo, 'studentName': studentName, 'fromClass': fromClass, 'toClass': toClass, 'promotionDate': promotionDate};

  factory StudentPromotion.fromJson(Map<String, dynamic> json) => StudentPromotion(
        id: json['id'] as int, studentAdmissionNo: json['studentAdmissionNo'] as String,
        studentName: json['studentName'] as String, fromClass: json['fromClass'] as String,
        toClass: json['toClass'] as String, promotionDate: json['promotionDate'] as String,
      );
}

class AlumniRecord {
  AlumniRecord({required this.id, required this.name, required this.graduationYear, required this.profession});

  final int id;
  String name;
  String graduationYear;
  String profession;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'graduationYear': graduationYear, 'profession': profession};

  factory AlumniRecord.fromJson(Map<String, dynamic> json) => AlumniRecord(
        id: json['id'] as int, name: json['name'] as String,
        graduationYear: json['graduationYear'] as String, profession: json['profession'] as String,
      );
}
