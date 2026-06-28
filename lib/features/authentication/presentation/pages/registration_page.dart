import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:educare/core/constants/app_constants.dart';
import 'package:educare/core/services/api_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedCategory = 'Staff';
  String _selectedRole = 'Admin';
  final List<RegisteredUser> _createdUsers = [];
  RegisteredUser? _editingUser;
  final ApiService _api = ApiService();

  final List<String> _categories = ['Staff', 'Student', 'Parent', 'Admin'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final response = await _api.get('/auth/users');
      if (!mounted) return;
      setState(() {
        _createdUsers
          ..clear()
          ..addAll((response.data as List).map((item) => RegisteredUser.fromJson(Map<String, dynamic>.from(item as Map))));
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  List<String> _getRolesForCategory(String category) {
    switch (category) {
      case 'Staff':
        return ['Admin', 'Teacher', 'Staff', 'Counselor'];
      case 'Student':
        return ['Student'];
      case 'Parent':
        return ['Parent', 'Guardian'];
      case 'Admin':
        return ['Super Admin', 'Admin'];
      default:
        return ['User'];
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final payload = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'category': _selectedCategory,
        'role': _selectedRole,
      };
      if (_editingUser == null) {
        final response = await _api.post('/auth/register', data: {
          ...payload,
          'password': _passwordController.text,
        });
        _createdUsers.add(RegisteredUser.fromJson(Map<String, dynamic>.from(response.data as Map)));
      } else {
        final response = await _api.put('/auth/users/${_editingUser!.id}', data: payload);
        final saved = RegisteredUser.fromJson(Map<String, dynamic>.from(response.data as Map));
        final index = _createdUsers.indexWhere((item) => item.id == saved.id);
        _createdUsers[index] = saved;
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to save user to the backend.')));
      return;
    }
    setState(() {
      _editingUser = null;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _selectedCategory = 'Staff';
      _selectedRole = _getRolesForCategory('Staff').first;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User saved successfully with assigned role.')),
    );
  }

  Future<void> _deleteUser(RegisteredUser user) async {
    try {
      await _api.delete('/auth/users/${user.id}');
      if (mounted) setState(() => _createdUsers.remove(user));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to delete user from the backend.')));
      }
    }
  }

  void _editUser(RegisteredUser user) {
    setState(() {
      _editingUser = user;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _passwordController.text = 'unchanged';
      _selectedCategory = user.category;
      _selectedRole = user.role;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingUser = null;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _selectedCategory = 'Staff';
      _selectedRole = _getRolesForCategory('Staff').first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roles = _getRolesForCategory(_selectedCategory);
    if (!_selectedRole.contains(_selectedCategory) && !roles.contains(_selectedRole)) {
      _selectedRole = roles.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create a new account and assign user category and role.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Enter full name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter password';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                        _selectedRole = _getRolesForCategory(value).first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedRole = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    children: [
                      if (_editingUser != null)
                        TextButton(onPressed: _cancelEdit, child: const Text('Cancel Edit')),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(_editingUser == null ? 'Create User' : 'Save User'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_createdUsers.isNotEmpty) ...[
              const Text('Created users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _createdUsers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = _createdUsers[index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(user.email, style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 8),
                          Text('Category: ${user.category}'),
                          Text('Role: ${user.role}'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: 'Edit user',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _editUser(user),
                              ),
                              IconButton(
                                tooltip: 'Delete user',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteUser(user),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.login),
        icon: const Icon(Icons.login),
        label: const Text('Back to Login'),
      ),
    );
  }
}

class RegisteredUser {
  RegisteredUser({
    required this.id,
    required this.name,
    required this.email,
    required this.category,
    required this.role,
  });

  final int id;
  String name;
  String email;
  String category;
  String role;

  factory RegisteredUser.fromJson(Map<String, dynamic> json) => RegisteredUser(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        category: json['category'] as String,
        role: json['role'] as String,
      );
}
