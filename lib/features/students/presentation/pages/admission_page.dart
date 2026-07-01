import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/features/students/domain/entities/admission_request.dart';
import 'package:educare/features/students/presentation/keys/student_keys.dart';

class AdmissionPage extends ConsumerStatefulWidget {
  const AdmissionPage({super.key});

  @override
  ConsumerState<AdmissionPage> createState() => _AdmissionPageState();
}

class _AdmissionPageState extends ConsumerState<AdmissionPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'admissionFormKey');
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _dob = TextEditingController();
  final _grade = TextEditingController();
  final _section = TextEditingController();
  final _guardianName = TextEditingController();
  final _guardianPhone = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _dob.dispose();
    _grade.dispose();
    _section.dispose();
    _guardianName.dispose();
    _guardianPhone.dispose();
    super.dispose();
  }

  void _submit() {
    if (validateAndFocusFirstInvalid(_formKey) &&
        !ref.read(studentViewModelProvider).loading) {
      final request = AdmissionRequest(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        dateOfBirth: _dob.text.trim(),
        grade: _grade.text.trim(),
        section: _section.text.trim(),
        guardianName: _guardianName.text.trim(),
        guardianPhone: _guardianPhone.text.trim(),
      );
      ref.read(studentViewModelProvider.notifier).submitAdmission(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentViewModelProvider);

    return Scaffold(
      key: StudentKeys.admissionPage,
      appBar: AppBar(title: const Text('New Admission')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            key: StudentKeys.admissionForm,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.error != null)
                Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              if (state.admissionSuccess)
                Text(
                  'Admission submitted successfully!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              const SizedBox(height: 16),
              _buildTextField(_firstName, 'First name', 'firstNameField'),
              _buildTextField(_lastName, 'Last name', 'lastNameField'),
              _buildTextField(
                _email,
                'Email',
                'emailField',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(_dob, 'Date of birth', 'dobField'),
              _buildTextField(_grade, 'Grade', 'gradeField'),
              _buildTextField(_section, 'Section', 'sectionField'),
              _buildTextField(
                _guardianName,
                'Guardian name',
                'guardianNameField',
              ),
              _buildTextField(
                _guardianPhone,
                'Guardian phone',
                'guardianPhoneField',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: StudentKeys.admissionSubmitButton,
                onPressed: state.loading ? null : _submit,
                child: state.loading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Admission'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String fieldKey, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        key: Key(fieldKey),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) => (value?.isEmpty ?? true) ? 'Enter $label' : null,
      ),
    );
  }
}
