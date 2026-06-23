import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/students/presentation/keys/student_keys.dart';

class TransferCertificatePage extends ConsumerStatefulWidget {
  final int studentId;

  const TransferCertificatePage({super.key, required this.studentId});

  @override
  ConsumerState<TransferCertificatePage> createState() => _TransferCertificatePageState();
}

class _TransferCertificatePageState extends ConsumerState<TransferCertificatePage> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'transferFormKey');
  final _toSchool = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _toSchool.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    if ((_formKey.currentState?.validate() ?? false) && !ref.read(studentViewModelProvider).loading) {
      ref.read(studentViewModelProvider.notifier).requestTransferCertificate(widget.studentId, _toSchool.text.trim(), _reason.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentViewModelProvider);

    return Scaffold(
      key: StudentKeys.transferCertificatePage,
      appBar: AppBar(title: const Text('Transfer Certificate')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            key: StudentKeys.transferForm,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.error != null) Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              if (state.transferCertificate != null)
                Text('Transfer certificate requested for ${state.transferCertificate!.studentName}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('transferToSchoolField'),
                controller: _toSchool,
                decoration: const InputDecoration(labelText: 'Receiving School'),
                validator: (value) => (value?.isEmpty ?? true) ? 'Enter receiving school' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('transferReasonField'),
                controller: _reason,
                decoration: const InputDecoration(labelText: 'Reason'),
                maxLines: 4,
                validator: (value) => (value?.isEmpty ?? true) ? 'Enter reason for transfer' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('transferSubmitButton'),
                onPressed: state.loading ? null : _submit,
                child: state.loading ? const CircularProgressIndicator() : const Text('Request Certificate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
