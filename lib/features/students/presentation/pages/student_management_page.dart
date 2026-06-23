import 'package:flutter/material.dart';

class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({super.key});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  final List<StudentRecord> _students = [
    StudentRecord(
      id: 1,
      admissionNo: 'ADM-2024-001',
      name: 'Aarav Sharma',
      gender: 'Male',
      dob: '2010-05-15',
      bloodGroup: 'O+',
      address: 'Bangalore, Karnataka',
      mobileNumber: '9876543210',
      aadhaarNumber: '1234567890123456',
      category: 'General',
      religion: 'Hindu',
      currentClass: 'Grade 8',
      section: 'A',
      parentName: 'Rajesh Sharma',
      parentPhone: '9876543200',
    ),
    StudentRecord(
      id: 2,
      admissionNo: 'ADM-2024-002',
      name: 'Priya Patel',
      gender: 'Female',
      dob: '2010-08-22',
      bloodGroup: 'A+',
      address: 'Pune, Maharashtra',
      mobileNumber: '9123456789',
      aadhaarNumber: '1234567890123457',
      category: 'OBC',
      religion: 'Hindu',
      currentClass: 'Grade 9',
      section: 'B',
      parentName: 'Vikram Patel',
      parentPhone: '9123456780',
    ),
  ];

  final List<StudentDocument> _documents = [];
  final List<StudentPromotion> _promotions = [];
  final List<AlumniRecord> _alumni = [];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Registration', 'Add new students or edit existing registrations.', action: () => _showStudentDialog(context), actionLabel: 'New Admission'),
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
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showStudentDialog(context, student: student)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _students.removeAt(index))),
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

  Widget _buildProfilesTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Profiles', 'View and manage individual student records.'),
        Expanded(
          child: _students.isEmpty
              ? const Center(child: Text('No student profiles available.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        title: Text(student.name),
                        subtitle: Text(student.admissionNo),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Documents', 'Upload and manage student documents.', action: () => _showDocumentDialog(context), actionLabel: 'Upload Document'),
        Expanded(
          child: _documents.isEmpty
              ? const Center(child: Text('No documents uploaded yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _documents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = _documents[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(doc.fileName),
                        subtitle: Text('${doc.studentName} • ${doc.documentType}'),
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _documents.removeAt(index))),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPhotosTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Photos', 'Upload student profile photos.', action: () => _showPhotoDialog(context), actionLabel: 'Upload Photo'),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, size: 48),
                      const SizedBox(height: 8),
                      Text(student.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showPhotoDialog(context, student: student)),
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

  Widget _buildParentInfoTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Parent Details', 'Manage parent and guardian information.'),
        Expanded(
          child: _students.isEmpty
              ? const Center(child: Text('No parent information available.'))
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
                        title: Text(student.parentName),
                        subtitle: Text('${student.name} • ${student.parentPhone}'),
                        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _showParentDialog(context, student: student)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPromotionTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Promotion', 'Manage promotion and class upgrades.', action: () => _showPromotionDialog(context), actionLabel: 'Promote Student'),
        Expanded(
          child: _promotions.isEmpty
              ? const Center(child: Text('No promotions recorded yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _promotions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final promotion = _promotions[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(promotion.studentName),
                        subtitle: Text('${promotion.fromClass} → ${promotion.toClass} • ${promotion.promotionDate}'),
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _promotions.removeAt(index))),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTransferCertTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Transfer Certificates', 'Generate and manage transfer certificates.'),
        Expanded(
          child: _students.isEmpty
              ? const Center(child: Text('No students available for transfer certificates.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(student.name),
                        subtitle: Text('${student.admissionNo} • ${student.currentClass}-${student.section}'),
                        trailing: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transfer certificate generated for ${student.name}.'))), child: const Text('Generate')),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAlumniTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Alumni Management', 'Track and manage alumni records.', action: () => _showAlumniDialog(context), actionLabel: 'Add Alumni'),
        Expanded(
          child: _alumni.isEmpty
              ? const Center(child: Text('No alumni records yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _alumni.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final alum = _alumni[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(alum.name),
                        subtitle: Text('Batch ${alum.graduationYear} • ${alum.profession}'),
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _alumni.removeAt(index))),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showStudentDialog(BuildContext context, {StudentRecord? student}) {
    final nameController = TextEditingController(text: student?.name ?? '');
    final admissionNoController = TextEditingController(text: student?.admissionNo ?? '');
    final genderController = TextEditingController(text: student?.gender ?? '');
    final dobController = TextEditingController(text: student?.dob ?? '');
    final bloodGroupController = TextEditingController(text: student?.bloodGroup ?? '');
    final addressController = TextEditingController(text: student?.address ?? '');
    final mobileController = TextEditingController(text: student?.mobileNumber ?? '');
    final aadhaarController = TextEditingController(text: student?.aadhaarNumber ?? '');
    final categoryController = TextEditingController(text: student?.category ?? '');
    final religionController = TextEditingController(text: student?.religion ?? '');
    final classController = TextEditingController(text: student?.currentClass ?? '');
    final sectionController = TextEditingController(text: student?.section ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student == null ? 'New Admission' : 'Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: admissionNoController, decoration: const InputDecoration(labelText: 'Admission Number')),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Student Name')),
              TextField(controller: genderController, decoration: const InputDecoration(labelText: 'Gender')),
              TextField(controller: dobController, decoration: const InputDecoration(labelText: 'Date of Birth')),
              TextField(controller: bloodGroupController, decoration: const InputDecoration(labelText: 'Blood Group')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: mobileController, decoration: const InputDecoration(labelText: 'Mobile Number')),
              TextField(controller: aadhaarController, decoration: const InputDecoration(labelText: 'Aadhaar Number')),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: religionController, decoration: const InputDecoration(labelText: 'Religion')),
              TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class')),
              TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter student name.')));
                return;
              }
              setState(() {
                if (student != null) {
                  student.name = name;
                  student.admissionNo = admissionNoController.text.trim();
                  student.gender = genderController.text.trim();
                  student.dob = dobController.text.trim();
                  student.bloodGroup = bloodGroupController.text.trim();
                  student.address = addressController.text.trim();
                  student.mobileNumber = mobileController.text.trim();
                  student.aadhaarNumber = aadhaarController.text.trim();
                  student.category = categoryController.text.trim();
                  student.religion = religionController.text.trim();
                  student.currentClass = classController.text.trim();
                  student.section = sectionController.text.trim();
                } else {
                  _students.add(StudentRecord(
                    id: _students.isEmpty ? 1 : _students.last.id + 1,
                    admissionNo: admissionNoController.text.trim(),
                    name: name,
                    gender: genderController.text.trim(),
                    dob: dobController.text.trim(),
                    bloodGroup: bloodGroupController.text.trim(),
                    address: addressController.text.trim(),
                    mobileNumber: mobileController.text.trim(),
                    aadhaarNumber: aadhaarController.text.trim(),
                    category: categoryController.text.trim(),
                    religion: religionController.text.trim(),
                    currentClass: classController.text.trim(),
                    section: sectionController.text.trim(),
                    parentName: '',
                    parentPhone: '',
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

  void _showDocumentDialog(BuildContext context) {
    final fileNameController = TextEditingController();
    final docTypeController = TextEditingController();
    String selectedStudent = _students.isNotEmpty ? _students.first.name : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStudent.isNotEmpty ? selectedStudent : null,
                items: _students.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Student'),
                onChanged: (value) => selectedStudent = value ?? selectedStudent,
              ),
              TextField(controller: docTypeController, decoration: const InputDecoration(labelText: 'Document Type')),
              TextField(controller: fileNameController, decoration: const InputDecoration(labelText: 'File Name')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final fileName = fileNameController.text.trim();
              if (fileName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter file name.')));
                return;
              }
              setState(() {
                _documents.add(StudentDocument(
                  id: _documents.isEmpty ? 1 : _documents.last.id + 1,
                  studentName: selectedStudent,
                  documentType: docTypeController.text.trim(),
                  fileName: fileName,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, {StudentRecord? student}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Photo${student != null ? ' - ${student.name}' : ''}'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_upload, size: 64),
              SizedBox(height: 16),
              Text('Click to select a photo from your device.'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo uploaded successfully.')));
              Navigator.pop(context);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showParentDialog(BuildContext context, {StudentRecord? student}) {
    final parentNameController = TextEditingController(text: student?.parentName ?? '');
    final parentPhoneController = TextEditingController(text: student?.parentPhone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parent Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: parentNameController, decoration: const InputDecoration(labelText: 'Parent Name')),
              TextField(controller: parentPhoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (student != null) {
                setState(() {
                  student.parentName = parentNameController.text.trim();
                  student.parentPhone = parentPhoneController.text.trim();
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPromotionDialog(BuildContext context) {
    String selectedStudent = _students.isNotEmpty ? _students.first.name : '';
    final toClassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promote Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStudent.isNotEmpty ? selectedStudent : null,
                items: _students.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                decoration: const InputDecoration(labelText: 'Student'),
                onChanged: (value) => selectedStudent = value ?? selectedStudent,
              ),
              TextField(controller: toClassController, decoration: const InputDecoration(labelText: 'New Class')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final toClass = toClassController.text.trim();
              if (toClass.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter new class.')));
                return;
              }
              final student = _students.firstWhere((s) => s.name == selectedStudent, orElse: () => StudentRecord(id: 0, admissionNo: '', name: '', gender: '', dob: '', bloodGroup: '', address: '', mobileNumber: '', aadhaarNumber: '', category: '', religion: '', currentClass: '', section: '', parentName: '', parentPhone: ''));
              setState(() {
                _promotions.add(StudentPromotion(
                  id: _promotions.isEmpty ? 1 : _promotions.last.id + 1,
                  studentName: selectedStudent,
                  fromClass: student.currentClass,
                  toClass: toClass,
                  promotionDate: DateTime.now().toString().split(' ').first,
                ));
                if (student.id != 0) {
                  student.currentClass = toClass;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Promote'),
          ),
        ],
      ),
    );
  }

  void _showAlumniDialog(BuildContext context) {
    final nameController = TextEditingController();
    final yearController = TextEditingController();
    final professionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Alumni'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: yearController, decoration: const InputDecoration(labelText: 'Graduation Year')),
              TextField(controller: professionController, decoration: const InputDecoration(labelText: 'Current Profession')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter name.')));
                return;
              }
              setState(() {
                _alumni.add(AlumniRecord(
                  id: _alumni.isEmpty ? 1 : _alumni.last.id + 1,
                  name: name,
                  graduationYear: yearController.text.trim(),
                  profession: professionController.text.trim(),
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class StudentRecord {
  StudentRecord({
    required this.id,
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
    required this.parentName,
    required this.parentPhone,
  });

  final int id;
  String admissionNo;
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
  String parentName;
  String parentPhone;
}

class StudentDocument {
  StudentDocument({required this.id, required this.studentName, required this.documentType, required this.fileName});

  final int id;
  final String studentName;
  final String documentType;
  final String fileName;
}

class StudentPromotion {
  StudentPromotion({required this.id, required this.studentName, required this.fromClass, required this.toClass, required this.promotionDate});

  final int id;
  final String studentName;
  final String fromClass;
  final String toClass;
  final String promotionDate;
}

class AlumniRecord {
  AlumniRecord({required this.id, required this.name, required this.graduationYear, required this.profession});

  final int id;
  final String name;
  final String graduationYear;
  final String profession;
}

