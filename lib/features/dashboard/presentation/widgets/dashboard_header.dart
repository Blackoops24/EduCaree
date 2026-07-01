import 'package:educare/core/providers.dart';
import 'package:educare/core/constants/app_constants.dart';
import 'package:educare/core/widgets/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardHeader extends ConsumerStatefulWidget {
  const DashboardHeader({super.key});

  @override
  ConsumerState<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends ConsumerState<DashboardHeader> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleTheme(bool value) {
    ref.read(themeModeProvider.notifier).toggleTheme();
  }

  void _performSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;
    final destinations = <String, List<String>>{
      AppRoutes.students: [
        'student',
        'admission',
        'parent',
        'promotion',
        'alumni',
        'document',
        'transfer',
      ],
      AppRoutes.staff: ['staff', 'teacher', 'employee', 'salary', 'leave'],
      AppRoutes.academics: [
        'academic',
        'class',
        'subject',
        'exam',
        'marks',
        'timetable',
      ],
      AppRoutes.attendance: ['attendance', 'biometric', 'face'],
      AppRoutes.fees: ['fee', 'payment'],
      AppRoutes.library: ['library', 'book'],
      AppRoutes.transport: ['transport', 'vehicle', 'route', 'driver'],
      AppRoutes.inventory: ['inventory', 'asset', 'stock'],
      AppRoutes.notifications: ['notification'],
      AppRoutes.messages: ['message'],
      AppRoutes.calendar: ['calendar', 'event'],
    };
    for (final entry in destinations.entries) {
      if (entry.value.any(
        (keyword) => keyword.contains(query) || query.contains(keyword),
      )) {
        context.go(entry.key);
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No module found for "${_searchController.text.trim()}".',
        ),
      ),
    );
  }

  Future<void> _handleProfileAction(String value) async {
    switch (value) {
      case 'My Profile':
        if (!mounted) return;
        context.go(AppRoutes.myProfile);
        break;
      case 'Settings':
        if (!mounted) return;
        context.go(AppRoutes.settings);
        break;
      case 'Change Password':
        await _showChangePasswordDialog();
        break;
      case 'Logout':
        ref.read(authViewModelProvider.notifier).logout();
        if (!mounted) return;
        context.go(AppRoutes.login);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );
        break;
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        String? currentPasswordError;
        bool submitting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Change Password'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current password is required';
                      }
                      return currentPasswordError;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'New password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm New Password',
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: submitting
                    ? null
                    : () async {
                        currentPasswordError = null;
                        if (!validateAndFocusFirstInvalid(formKey)) return;
                        setDialogState(() => submitting = true);
                        final error = await ref
                            .read(authViewModelProvider.notifier)
                            .changePassword(
                              currentPassword: currentPasswordController.text,
                              newPassword: newPasswordController.text,
                            );
                        if (!dialogContext.mounted) return;
                        if (error != null) {
                          setDialogState(() {
                            submitting = false;
                            currentPasswordError = error;
                          });
                          validateAndFocusFirstInvalid(formKey);
                          return;
                        }
                        Navigator.of(dialogContext).pop(true);
                      },
                child: Text(submitting ? 'Updating…' : 'Update'),
              ),
            ],
          ),
        );
      },
    );

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    if (submitted == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 4,
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 900;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isCompact) ...[
                  _buildTopRow(context, isDark),
                  const SizedBox(height: 12),
                  _buildSearchBar(context),
                  const SizedBox(height: 8),
                  _buildActionRow(context, isDark),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _buildTopRow(context, isDark)),
                      const SizedBox(width: 20),
                      Expanded(flex: 6, child: _buildSearchBar(context)),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: _buildActionRow(context, isDark),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Builder(
          builder: (context) => IconButton(
            key: const Key('header_menu_button'),
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
            tooltip: 'Open navigation menu',
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          key: const Key('header_logo'),
          onTap: () => context.go(AppRoutes.dashboard),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              const Text(
                'EduCare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      key: const Key('header_search_textfield'),
      controller: _searchController,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        hintText: 'Search students, teachers, staff, fees, books, vehicles',
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.clear, color: Colors.black54),
                onPressed: () => setState(_searchController.clear),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      textInputAction: TextInputAction.search,
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => _performSearch(),
    );
  }

  Widget _buildActionRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          key: const Key('header_notification_icon'),
          onPressed: () => context.go(AppRoutes.notifications),
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          tooltip: 'Notifications',
        ),
        IconButton(
          key: const Key('header_message_icon'),
          onPressed: () => context.go(AppRoutes.messages),
          icon: const Icon(Icons.message_outlined, color: Colors.white),
          tooltip: 'Messages',
        ),
        IconButton(
          key: const Key('header_calendar_icon'),
          onPressed: () => context.go(AppRoutes.calendar),
          icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
          tooltip: 'Calendar',
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            const Icon(Icons.dark_mode, color: Colors.white70, size: 18),
            Switch.adaptive(
              key: const Key('header_darkmode_toggle'),
              activeThumbColor: Colors.white,
              value: isDark,
              onChanged: _toggleTheme,
            ),
          ],
        ),
        const SizedBox(width: 6),
        PopupMenuButton<String>(
          key: const Key('profile_menu_button'),
          tooltip: 'User profile menu',
          offset: const Offset(0, 56),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: _handleProfileAction,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'My Profile', child: Text('My Profile')),
            const PopupMenuItem(value: 'Settings', child: Text('Settings')),
            const PopupMenuItem(
              value: 'Change Password',
              child: Text('Change Password'),
            ),
            const PopupMenuItem(
              value: 'Logout',
              child: Text('Logout'),
              key: Key('logout_button'),
            ),
          ],
          child: const CircleAvatar(
            key: Key('header_profile_avatar'),
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
