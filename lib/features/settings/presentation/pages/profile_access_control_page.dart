import 'package:flutter/material.dart';

class ProfileAccessControlPage extends StatefulWidget {
  const ProfileAccessControlPage({super.key});

  @override
  State<ProfileAccessControlPage> createState() => _ProfileAccessControlPageState();
}

class _ProfileAccessControlPageState extends State<ProfileAccessControlPage> {
  final List<ProfileAccessConfig> _accessConfigs = [
    ProfileAccessConfig(
      id: 1,
      category: 'Staff',
      role: 'Admin',
      screensAccess: [
        ScreenAccess(name: 'Dashboard', module: 'Core', hasAccess: true),
        ScreenAccess(name: 'Student Management', module: 'Students', hasAccess: true),
        ScreenAccess(name: 'Staff Management', module: 'Staff', hasAccess: true),
        ScreenAccess(name: 'Academic Management', module: 'Academics', hasAccess: true),
        ScreenAccess(name: 'Attendance Management', module: 'Attendance', hasAccess: true),
        ScreenAccess(name: 'Fee Management', module: 'Fees', hasAccess: true),
        ScreenAccess(name: 'Library Management', module: 'Library', hasAccess: true),
        ScreenAccess(name: 'Transport Management', module: 'Transport', hasAccess: true),
        ScreenAccess(name: 'Inventory Management', module: 'Inventory', hasAccess: true),
        ScreenAccess(name: 'Notifications', module: 'Notifications', hasAccess: true),
      ],
    ),
    ProfileAccessConfig(
      id: 2,
      category: 'Staff',
      role: 'Teacher',
      screensAccess: [
        ScreenAccess(name: 'Dashboard', module: 'Core', hasAccess: true),
        ScreenAccess(name: 'Student Management', module: 'Students', hasAccess: true),
        ScreenAccess(name: 'Academic Management', module: 'Academics', hasAccess: true),
        ScreenAccess(name: 'Attendance Management', module: 'Attendance', hasAccess: true),
        ScreenAccess(name: 'Fee Management', module: 'Fees', hasAccess: false),
        ScreenAccess(name: 'Library Management', module: 'Library', hasAccess: false),
        ScreenAccess(name: 'Transport Management', module: 'Transport', hasAccess: false),
        ScreenAccess(name: 'Inventory Management', module: 'Inventory', hasAccess: false),
        ScreenAccess(name: 'Notifications', module: 'Notifications', hasAccess: true),
      ],
    ),
  ];

  final List<String> _categories = ['Staff', 'Student', 'Parent', 'Admin'];
  final List<String> _staffRoles = ['Admin', 'Teacher', 'Staff', 'Counselor'];
  final List<String> _studentRoles = ['Student'];
  final List<String> _parentRoles = ['Parent', 'Guardian'];
  final List<String> _adminRoles = ['Super Admin', 'Admin'];

  final List<ScreenAccess> _availableScreens = [
    ScreenAccess(name: 'Dashboard', module: 'Core', hasAccess: false),
    ScreenAccess(name: 'Student Management', module: 'Students', hasAccess: false),
    ScreenAccess(name: 'Staff Management', module: 'Staff', hasAccess: false),
    ScreenAccess(name: 'Academic Management', module: 'Academics', hasAccess: false),
    ScreenAccess(name: 'Attendance Management', module: 'Attendance', hasAccess: false),
    ScreenAccess(name: 'Fee Management', module: 'Fees', hasAccess: false),
    ScreenAccess(name: 'Library Management', module: 'Library', hasAccess: false),
    ScreenAccess(name: 'Transport Management', module: 'Transport', hasAccess: false),
    ScreenAccess(name: 'Inventory Management', module: 'Inventory', hasAccess: false),
    ScreenAccess(name: 'Notifications', module: 'Notifications', hasAccess: false),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Access Control'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Access Configurations'),
              Tab(text: 'Create New Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAccessConfigsTab(context),
            _buildCreateProfileTab(context),
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

  Widget _buildAccessConfigsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Access Configurations',
          'View and manage role-based access permissions.',
          action: () => _showDeleteConfirmation(context),
          actionLabel: 'Edit',
        ),
        Expanded(
          child: _accessConfigs.isEmpty
              ? const Center(child: Text('No access configurations created.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _accessConfigs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final config = _accessConfigs[index];
                    final allowedScreens = config.screensAccess.where((s) => s.hasAccess).length;
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        title: Text('${config.category} - ${config.role}'),
                        subtitle: Text('$allowedScreens screens accessible'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Accessible Screens:', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: config.screensAccess
                                      .where((s) => s.hasAccess)
                                      .map((s) => Chip(label: Text(s.name), avatar: Icon(Icons.check_circle, size: 18)))
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _showEditConfigDialog(context, config),
                                      child: const Text('Edit'),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: () => setState(() => _accessConfigs.removeAt(index)),
                                      child: const Text('Delete'),
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

  Widget _buildCreateProfileTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create New Access Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Define a new role with specific screen access permissions.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showCreateProfileDialog(context),
            child: const Text('+ Create New Profile'),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Templates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Staff Admin', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('Full access to all modules and screens.', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  SizedBox(height: 12),
                  Text('Staff Teacher', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('Access: Dashboard, Academics, Attendance, Notifications.', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  SizedBox(height: 12),
                  Text('Student Parent', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('Limited access to student fees and academic reports.', style: TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateProfileDialog(BuildContext context) {
    String selectedCategory = _categories.first;
    List<String> roles = _getRolesForCategory(selectedCategory);
    String selectedRole = roles.first;
    List<ScreenAccess> selectedScreens = List.from(_availableScreens);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Access Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  decoration: const InputDecoration(labelText: 'Select Category'),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value ?? selectedCategory;
                      roles = _getRolesForCategory(selectedCategory);
                      selectedRole = roles.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  decoration: const InputDecoration(labelText: 'Select Role'),
                  onChanged: (value) => setDialogState(() => selectedRole = value ?? selectedRole),
                ),
                const SizedBox(height: 20),
                const Text('Screen Access Permissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                ..._availableScreens.asMap().entries.map((entry) {
                  final index = entry.key;
                  final screen = entry.value;
                  return CheckboxListTile(
                    title: Text(screen.name),
                    subtitle: Text(screen.module, style: const TextStyle(fontSize: 12)),
                    value: selectedScreens[index].hasAccess,
                    onChanged: (value) => setDialogState(() => selectedScreens[index].hasAccess = value ?? false),
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _accessConfigs.add(ProfileAccessConfig(
                    id: _accessConfigs.isEmpty ? 1 : _accessConfigs.last.id + 1,
                    category: selectedCategory,
                    role: selectedRole,
                    screensAccess: selectedScreens.map((s) => ScreenAccess(name: s.name, module: s.module, hasAccess: s.hasAccess)).toList(),
                  ));
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile "$selectedRole" created for category "$selectedCategory"')),
                );
                Navigator.pop(context);
              },
              child: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditConfigDialog(BuildContext context, ProfileAccessConfig config) {
    List<ScreenAccess> editableScreens = config.screensAccess.map((s) => ScreenAccess(name: s.name, module: s.module, hasAccess: s.hasAccess)).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Access - ${config.category} / ${config.role}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text('Screen Access Permissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                ...editableScreens.asMap().entries.map((entry) {
                  final index = entry.key;
                  final screen = entry.value;
                  return CheckboxListTile(
                    title: Text(screen.name),
                    subtitle: Text(screen.module, style: const TextStyle(fontSize: 12)),
                    value: screen.hasAccess,
                    onChanged: (value) => setDialogState(() => editableScreens[index].hasAccess = value ?? false),
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  config.screensAccess = editableScreens;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile "${config.role}" updated successfully')),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Click delete button on individual profiles to remove them.')),
    );
  }

  List<String> _getRolesForCategory(String category) {
    switch (category) {
      case 'Staff':
        return _staffRoles;
      case 'Student':
        return _studentRoles;
      case 'Parent':
        return _parentRoles;
      case 'Admin':
        return _adminRoles;
      default:
        return [];
    }
  }
}

class ProfileAccessConfig {
  ProfileAccessConfig({
    required this.id,
    required this.category,
    required this.role,
    required this.screensAccess,
  });

  final int id;
  final String category;
  final String role;
  List<ScreenAccess> screensAccess;
}

class ScreenAccess {
  ScreenAccess({
    required this.name,
    required this.module,
    required this.hasAccess,
  });

  final String name;
  final String module;
  bool hasAccess;
}
