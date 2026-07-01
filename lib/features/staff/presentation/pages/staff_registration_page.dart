import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:educare/features/staff/domain/entities/staff_member.dart';
import 'package:educare/features/staff/presentation/keys/staff_keys.dart';

class StaffRegistrationPage extends ConsumerStatefulWidget {
  const StaffRegistrationPage({super.key});

  @override
  ConsumerState<StaffRegistrationPage> createState() =>
      _StaffRegistrationPageState();
}

class _StaffRegistrationPageState extends ConsumerState<StaffRegistrationPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'staffRegistrationForm');
  final _employeeId = TextEditingController();
  final _name = TextEditingController();
  final _designation = TextEditingController();
  final _department = TextEditingController();
  final _qualification = TextEditingController();
  final _joiningDate = TextEditingController();
  final _salary = TextEditingController();

  @override
  void dispose() {
    _employeeId.dispose();
    _name.dispose();
    _designation.dispose();
    _department.dispose();
    _qualification.dispose();
    _joiningDate.dispose();
    _salary.dispose();
    super.dispose();
  }

  void _submit() {
    if (validateAndFocusFirstInvalid(_formKey) &&
        !ref.read(staffViewModelProvider).loading) {
      final staff = StaffMember(
        id: 0,
        employeeId: _employeeId.text.trim(),
        name: _name.text.trim(),
        designation: _designation.text.trim(),
        department: _department.text.trim(),
        qualification: _qualification.text.trim(),
        joiningDate: _joiningDate.text.trim(),
        salary: double.tryParse(_salary.text.trim()) ?? 0,
      );
      ref.read(staffViewModelProvider.notifier).registerStaff(staff);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffViewModelProvider);

    return Scaffold(
      key: StaffKeys.registrationPage,
      appBar: AppBar(title: const Text('Employee Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.error != null)
                Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              if (state.registrationSuccess)
                Text(
                  'Registration completed successfully!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              const SizedBox(height: 16),
              _buildTextField(
                _employeeId,
                'Employee ID',
                const Key('employeeIdField'),
              ),
              _buildTextField(_name, 'Name', const Key('nameField')),
              _buildTextField(
                _designation,
                'Designation',
                const Key('designationField'),
              ),
              _buildTextField(
                _department,
                'Department',
                const Key('departmentField'),
              ),
              _buildTextField(
                _qualification,
                'Qualification',
                const Key('qualificationField'),
              ),
              _buildTextField(
                _joiningDate,
                'Joining Date',
                const Key('joiningDateField'),
              ),
              _buildTextField(
                _salary,
                'Salary',
                const Key('salaryField'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: StaffKeys.registerStaffButton,
                onPressed: state.loading ? null : _submit,
                child: state.loading
                    ? const CircularProgressIndicator()
                    : const Text('Register Employee'),
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
    Key key, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        key: key,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) => (value?.isEmpty ?? true) ? 'Enter $label' : null,
      ),
    );
  }
}
