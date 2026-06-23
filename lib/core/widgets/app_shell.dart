import 'package:educare/core/constants/app_constants.dart';
import 'package:educare/features/dashboard/presentation/widgets/dashboard_footer.dart';
import 'package:educare/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    required this.location,
    super.key,
  });

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _AppNavigationDrawer(location: location),
      bottomNavigationBar: const DashboardFooter(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardHeader(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _AppNavigationDrawer extends StatelessWidget {
  const _AppNavigationDrawer({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final items = <({String label, String route, IconData icon})>[
      (label: 'Dashboard', route: AppRoutes.dashboard, icon: Icons.dashboard_outlined),
      (label: 'Students', route: AppRoutes.students, icon: Icons.school_outlined),
      (label: 'Staff', route: AppRoutes.staff, icon: Icons.groups_outlined),
      (label: 'Academics', route: AppRoutes.academics, icon: Icons.menu_book_outlined),
      (label: 'Attendance', route: AppRoutes.attendance, icon: Icons.fact_check_outlined),
      (label: 'Fees', route: AppRoutes.fees, icon: Icons.receipt_long_outlined),
      (label: 'Transport', route: AppRoutes.transport, icon: Icons.directions_bus_outlined),
      (label: 'Inventory', route: AppRoutes.inventory, icon: Icons.inventory_2_outlined),
      (label: 'Notifications', route: AppRoutes.notifications, icon: Icons.notifications_outlined),
      (label: 'Messages', route: AppRoutes.messages, icon: Icons.message_outlined),
      (label: 'Calendar', route: AppRoutes.calendar, icon: Icons.calendar_today_outlined),
      (label: 'Library', route: AppRoutes.library, icon: Icons.library_books_outlined),
      (label: 'Access Control', route: AppRoutes.profileAccessControl, icon: Icons.security_outlined),
    ];

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'EduCare Navigation',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items.map((item) {
                final isSelected = location == item.route || location.startsWith('${item.route}/');
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  selected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go(item.route);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}