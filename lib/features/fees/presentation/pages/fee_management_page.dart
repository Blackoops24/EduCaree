import 'package:flutter/material.dart';

class FeeManagementPage extends StatefulWidget {
  const FeeManagementPage({super.key});

  @override
  State<FeeManagementPage> createState() => _FeeManagementPageState();
}

class _FeeManagementPageState extends State<FeeManagementPage> {
  final List<FeeStructure> _structures = [
    FeeStructure(id: 1, name: 'Annual Tuition', amount: 65000, description: 'Standard academic year tuition fee'),
    FeeStructure(id: 2, name: 'Transport Fee', amount: 12000, description: 'Bus transport fee per academic year'),
  ];

  final List<FeeCategory> _categories = [
    FeeCategory(id: 1, name: 'Tuition', description: 'Classroom instruction charges'),
    FeeCategory(id: 2, name: 'Transport', description: 'Bus and van services'),
    FeeCategory(id: 3, name: 'Library', description: 'Library and resource access'),
  ];

  final List<InstallmentPlan> _installments = [
    InstallmentPlan(id: 1, name: 'Term 1', dueDate: '2026-07-10', amount: 22000, paid: false),
    InstallmentPlan(id: 2, name: 'Term 2', dueDate: '2026-09-10', amount: 22000, paid: false),
    InstallmentPlan(id: 3, name: 'Term 3', dueDate: '2026-11-10', amount: 21000, paid: true),
  ];

  final List<FeeCollection> _collections = [
    FeeCollection(
      id: 1,
      studentName: 'Aarav Sharma',
      category: 'Tuition',
      amount: 22000,
      paidOn: '2026-06-05',
      paymentMethod: 'Razorpay',
      receiptId: 'RCPT-1001',
    ),
  ];

  final List<PaymentGateway> _gateways = [
    PaymentGateway(name: 'Razorpay', enabled: true),
    PaymentGateway(name: 'PhonePe', enabled: false),
    PaymentGateway(name: 'Stripe', enabled: true),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fee Management'),
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: 'Structure'),
              Tab(text: 'Categories'),
              Tab(text: 'Installments'),
              Tab(text: 'Collection'),
              Tab(text: 'Payments'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStructureTab(context),
            _buildCategoryTab(context),
            _buildInstallmentTab(context),
            _buildCollectionTab(context),
            _buildPaymentsTab(context),
            _buildReportsTab(context),
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

  Widget _buildStructureTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Fee Structure', 'Create and manage fee heads for your school.', action: () => _showStructureDialog(context), actionLabel: 'Add Structure'),
        Expanded(
          child: _structures.isEmpty
              ? const Center(child: Text('No fee structures have been added yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _structures.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final structure = _structures[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(structure.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${structure.description}\nAmount: ₹${structure.amount.toStringAsFixed(0)}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showStructureDialog(context, structure: structure),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => _structures.removeAt(index)),
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

  Widget _buildCategoryTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Fee Categories', 'Organize fees by distinct categories.', action: () => _showCategoryDialog(context), actionLabel: 'Add Category'),
        Expanded(
          child: _categories.isEmpty
              ? const Center(child: Text('No categories defined yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(category.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showCategoryDialog(context, category: category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => _categories.removeAt(index)),
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

  Widget _buildInstallmentTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Installments', 'Manage fee installment schedules and payment status.', action: () => _showInstallmentDialog(context), actionLabel: 'Add Installment'),
        Expanded(
          child: _installments.isEmpty
              ? const Center(child: Text('No installments created yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _installments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final installment = _installments[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(installment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Due: ${installment.dueDate} • Amount: ₹${installment.amount.toStringAsFixed(0)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(installment.paid ? Icons.check_circle : Icons.pending, color: installment.paid ? Colors.green : Colors.orange),
                              onPressed: () => setState(() => installment.paid = !installment.paid),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showInstallmentDialog(context, installment: installment),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => _installments.removeAt(index)),
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

  Widget _buildCollectionTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Fee Collection', 'Record collections and track payment status.', action: () => _showCollectionDialog(context), actionLabel: 'Collect Fee'),
        Expanded(
          child: _collections.isEmpty
              ? const Center(child: Text('No fee collections recorded yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _collections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final collection = _collections[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('${collection.studentName} • ₹${collection.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${collection.category} • ${collection.paymentMethod} • Paid on ${collection.paidOn}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: collection.receiptId != null
                                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Downloading receipt ${collection.receiptId}...')),
                                      )
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => _collections.removeAt(index)),
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

  Widget _buildPaymentsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Online Payments', 'Enable and configure payment gateways.'),
          const SizedBox(height: 12),
          Column(
            children: _gateways
                .map((gateway) => SwitchListTile(
                      value: gateway.enabled,
                      title: Text(gateway.name),
                      subtitle: const Text('Enable to accept payments using this gateway.'),
                      onChanged: (value) => setState(() => gateway.enabled = value),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text('Gateway Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _gateways
                .map((gateway) => Chip(
                      label: Text(gateway.name),
                      avatar: Icon(gateway.enabled ? Icons.check_circle : Icons.offline_bolt, color: gateway.enabled ? Colors.green : Colors.red),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payments Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Razorpay test payment initiated.'))),
                    child: const Text('Test Razorpay Payment'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PhonePe test payment initiated.'))),
                    child: const Text('Test PhonePe Payment'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stripe test payment initiated.'))),
                    child: const Text('Test Stripe Payment'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    final totalCollected = _collections.fold<double>(0, (sum, item) => sum + item.amount);
    final defaulters = _installments.where((plan) => !plan.paid).toList();
    final pendingCount = defaulters.length;
    final pendingAmount = defaulters.fold<double>(0, (sum, item) => sum + item.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Fee Reports', 'View the latest collection and defaulter reports.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ReportCard(title: 'Total Collected', value: '₹${totalCollected.toStringAsFixed(0)}'),
              _ReportCard(title: 'Pending Installments', value: pendingCount.toString()),
              _ReportCard(title: 'Pending Amount', value: '₹${pendingAmount.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 22),
          const Text('Fee Collection Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _collections.isEmpty
              ? const Text('No collections available.')
              : Column(
                  children: _collections
                      .map((collection) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text('${collection.studentName} • ₹${collection.amount.toStringAsFixed(0)}'),
                              subtitle: Text('${collection.category} • ${collection.paymentMethod} • ${collection.paidOn}'),
                              trailing: Text(collection.receiptId ?? 'No Receipt', style: const TextStyle(fontSize: 12)),
                            ),
                          ))
                      .toList(),
                ),
          const SizedBox(height: 22),
          const Text('Defaulter Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          defaulters.isEmpty
              ? const Text('No defaulters at the moment.')
              : Column(
                  children: defaulters
                      .map((item) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text('Due ${item.dueDate} • ₹${item.amount.toStringAsFixed(0)}'),
                            ),
                          ))
                      .toList(),
                ),
          const SizedBox(height: 22),
          const Text('Generate / Download Receipts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _collections.isEmpty
              ? const Text('No receipts available yet.')
              : Column(
                  children: _collections.map((collection) {
                    final receiptLabel = collection.receiptId ?? 'Generate Receipt';
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(collection.studentName),
                        subtitle: Text('₹${collection.amount.toStringAsFixed(0)} • ${collection.paymentMethod}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            if (collection.receiptId != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloading receipt ${collection.receiptId}...')),
                              );
                              return;
                            }
                            setState(() {
                              collection.receiptId = 'RCPT-${1000 + collection.id}';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PDF receipt generated successfully.')),
                            );
                          },
                          child: Text(receiptLabel),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  void _showStructureDialog(BuildContext context, {FeeStructure? structure}) {
    final nameController = TextEditingController(text: structure?.name ?? '');
    final amountController = TextEditingController(text: structure?.amount.toString() ?? '');
    final descriptionController = TextEditingController(text: structure?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(structure == null ? 'New Fee Structure' : 'Edit Fee Structure'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Structure name')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final amount = double.tryParse(amountController.text.trim()) ?? 0;
              if (name.isEmpty || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid details')));
                return;
              }
              setState(() {
                if (structure != null) {
                  structure.name = name;
                  structure.amount = amount;
                  structure.description = descriptionController.text.trim();
                } else {
                  _structures.add(FeeStructure(
                    id: _structures.isEmpty ? 1 : _structures.last.id + 1,
                    name: name,
                    amount: amount,
                    description: descriptionController.text.trim(),
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

  void _showCategoryDialog(BuildContext context, {FeeCategory? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController = TextEditingController(text: category?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'New Fee Category' : 'Edit Fee Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Category name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a category name')));
                return;
              }
              setState(() {
                if (category != null) {
                  category.name = name;
                  category.description = descriptionController.text.trim();
                } else {
                  _categories.add(FeeCategory(
                    id: _categories.isEmpty ? 1 : _categories.last.id + 1,
                    name: name,
                    description: descriptionController.text.trim(),
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

  void _showInstallmentDialog(BuildContext context, {InstallmentPlan? installment}) {
    final nameController = TextEditingController(text: installment?.name ?? '');
    final dueDateController = TextEditingController(text: installment?.dueDate ?? '');
    final amountController = TextEditingController(text: installment?.amount.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(installment == null ? 'New Installment' : 'Edit Installment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Installment name')),
              TextField(controller: dueDateController, decoration: const InputDecoration(labelText: 'Due date')), 
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final dueDate = dueDateController.text.trim();
              final amount = double.tryParse(amountController.text.trim()) ?? 0;
              if (name.isEmpty || dueDate.isEmpty || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid installment details')));
                return;
              }
              setState(() {
                if (installment != null) {
                  installment.name = name;
                  installment.dueDate = dueDate;
                  installment.amount = amount;
                } else {
                  _installments.add(InstallmentPlan(
                    id: _installments.isEmpty ? 1 : _installments.last.id + 1,
                    name: name,
                    dueDate: dueDate,
                    amount: amount,
                    paid: false,
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

  void _showCollectionDialog(BuildContext context) {
    final studentController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = _categories.isNotEmpty ? _categories.first.name : '';
    String selectedMethod = _gateways.first.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Fee Collection'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentController, decoration: const InputDecoration(labelText: 'Student Name')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: _categories.map((category) => DropdownMenuItem(value: category.name, child: Text(category.name))).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) => selectedCategory = value ?? selectedCategory,
              ),
              const SizedBox(height: 8),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: _gateways.map((gateway) => DropdownMenuItem(value: gateway.name, child: Text(gateway.name))).toList(),
                decoration: const InputDecoration(labelText: 'Payment Method'),
                onChanged: (value) => selectedMethod = value ?? selectedMethod,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final studentName = studentController.text.trim();
              final amount = double.tryParse(amountController.text.trim()) ?? 0;
              if (studentName.isEmpty || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid student and amount.')));
                return;
              }
              final gateway = _gateways.firstWhere((gate) => gate.name == selectedMethod);
              if (!gateway.enabled) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${gateway.name} is disabled. Enable it in Payments tab.')));
                return;
              }
              setState(() {
                final newId = _collections.isEmpty ? 1 : _collections.last.id + 1;
                _collections.add(FeeCollection(
                  id: newId,
                  studentName: studentName,
                  category: selectedCategory,
                  amount: amount,
                  paidOn: DateTime.now().toString().split(' ').first,
                  paymentMethod: selectedMethod,
                  receiptId: 'RCPT-${1000 + newId}',
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Collect'),
          ),
        ],
      ),
    );
  }
}

class FeeStructure {
  FeeStructure({required this.id, required this.name, required this.amount, required this.description});

  final int id;
  String name;
  double amount;
  String description;
}

class FeeCategory {
  FeeCategory({required this.id, required this.name, required this.description});

  final int id;
  String name;
  String description;
}

class InstallmentPlan {
  InstallmentPlan({required this.id, required this.name, required this.dueDate, required this.amount, required this.paid});

  final int id;
  String name;
  String dueDate;
  double amount;
  bool paid;
}

class FeeCollection {
  FeeCollection({required this.id, required this.studentName, required this.category, required this.amount, required this.paidOn, required this.paymentMethod, this.receiptId});

  final int id;
  final String studentName;
  final String category;
  final double amount;
  final String paidOn;
  final String paymentMethod;
  String? receiptId;
}

class PaymentGateway {
  PaymentGateway({required this.name, required this.enabled});

  final String name;
  bool enabled;
}

class Receipt {
  Receipt({required this.id, required this.collectionId, required this.fileName});

  final int id;
  final int collectionId;
  final String fileName;
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;

  const _ReportCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
