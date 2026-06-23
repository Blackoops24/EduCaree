import 'package:educare/core/constants/app_constants.dart';
import 'package:educare/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    ref.read(studentViewModelProvider.notifier).loadStudents();
    ref.read(staffViewModelProvider.notifier).loadStaff();
    ref.read(academicViewModelProvider.notifier).fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentViewModelProvider);
    final staffState = ref.watch(staffViewModelProvider);
    final academicState = ref.watch(academicViewModelProvider);

    final totalStudents = studentState.students.length;
    final totalStaff = staffState.staff.length;
    final totalTeachers = staffState.staff.where((s) => s.designation.toLowerCase().contains('teach')).length;
    final totalClasses = academicState.classes.length;
    const totalFeeCollection = '₹1,250,000';
    const pendingFees = '₹145,000';
    const libraryBooks = 3280;
    const activeBuses = 8;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    const Text(
                      'School Overview',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A real-time overview of your school operations, attendance, fees and upcoming events.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _MetricCard(title: 'Total Students', value: '$totalStudents', icon: Icons.school, iconColor: Colors.blue),
                        _MetricCard(title: 'Total Teachers', value: '$totalTeachers', icon: Icons.person, iconColor: Colors.indigo),
                        _MetricCard(title: 'Total Staff', value: '$totalStaff', icon: Icons.group, iconColor: Colors.teal),
                        _MetricCard(title: 'Total Classes', value: '$totalClasses', icon: Icons.class_, iconColor: Colors.deepPurple),
                        _MetricCard(title: 'Total Fee Collection', value: totalFeeCollection, icon: Icons.attach_money, iconColor: Colors.green),
                        _MetricCard(title: 'Pending Fees', value: pendingFees, icon: Icons.pending_actions, iconColor: Colors.orange),
                        _MetricCard(title: 'Library Books', value: '$libraryBooks', icon: Icons.library_books, iconColor: Colors.brown),
                        _MetricCard(title: 'Active Buses', value: '$activeBuses', icon: Icons.directions_bus, iconColor: Colors.cyan),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildChartCard('Attendance Statistics', _attendanceChart(), Colors.blue.shade50)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildChartCard('Fee Collection Graph', _feeChart(), Colors.green.shade50)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildChartCard('Student Growth Graph', _growthChart(), Colors.purple.shade50, height: 260),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _InfoCard(
                          title: 'Today\'s Birthdays',
                          items: const ['Aarav Sharma – Grade 8', 'Mia Patel – Grade 10', 'Noah Singh – Grade 6'],
                        ),
                        _InfoCard(
                          title: 'Upcoming Events',
                          items: const ['Science Exhibition – May 20', 'Sports Day – June 5', 'Parent Meeting – June 12'],
                        ),
                        _InfoCard(
                          title: 'Recent Notifications',
                          items: const ['Library books due tomorrow', 'New exam schedule published', 'Fee reminder sent to parents'],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _DashboardCard(
                          title: 'Student Management',
                          subtitle: 'Admission, profiles, documents, alumni',
                          icon: Icons.school,
                          onTap: () => context.go(AppRoutes.students),
                        ),
                        _DashboardCard(
                          title: 'Staff Management',
                          subtitle: 'Registration, attendance, leave, salary',
                          icon: Icons.group,
                          onTap: () => context.go(AppRoutes.staff),
                        ),
                        _DashboardCard(
                          title: 'Academic Management',
                          subtitle: 'Classes, timetable, exams, report cards',
                          icon: Icons.book,
                          onTap: () => context.go(AppRoutes.academics),
                        ),
                        _DashboardCard(
                          title: 'Fee Management',
                          subtitle: 'Structure, collections, payments, reports',
                          icon: Icons.receipt_long,
                          onTap: () => context.go(AppRoutes.fees),
                        ),
                        _DashboardCard(
                          title: 'Transport Management',
                          subtitle: 'Vehicles, drivers, routes, allocation, GPS tracking',
                          icon: Icons.directions_bus,
                          onTap: () => context.go(AppRoutes.transport),
                        ),
                        _DashboardCard(
                          title: 'Inventory Management',
                          subtitle: 'Assets, lab gear, sports stock, damaged items',
                          icon: Icons.inventory_2,
                          onTap: () => context.go(AppRoutes.inventory),
                        ),
                        _DashboardCard(
                          title: 'Notifications',
                          subtitle: 'Push, email, SMS alerts and report exports',
                          icon: Icons.notifications_active,
                          onTap: () => context.go(AppRoutes.notifications),
                        ),
                        _DashboardCard(
                          title: 'Library Management',
                          subtitle: 'Categories, inventory, issue, returns, fines',
                          icon: Icons.library_books,
                          onTap: () => context.go(AppRoutes.library),
                        ),
                        _DashboardCard(
                          title: 'Attendance Management',
                          subtitle: 'Student/staff attendance, biometric, face recognition',
                          icon: Icons.person_add,
                          onTap: () => context.go(AppRoutes.attendance),
                        ),
                        _DashboardCard(
                          title: 'Profile Access Control',
                          subtitle: 'Manage role-based screen permissions',
                          icon: Icons.security,
                          onTap: () => context.go(AppRoutes.profileAccessControl),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget content, Color color, {double height = 200}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _attendanceChart() {
    final values = [88, 91, 94, 90, 93];
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(values.length, (index) {
        return Row(
          children: [
            SizedBox(width: 40, child: Text(labels[index], style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                children: [
                  Container(height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                  Container(
                    height: 18,
                    width: values[index] / 100 * MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('${values[index]}%', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        );
      }),
    );
  }

  Widget _feeChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
    final amounts = [85, 92, 106, 98, 112];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(amounts.length, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 22,
              height: amounts[index].toDouble(),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Text(months[index], style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        );
      }),
    );
  }

  Widget _growthChart() {
    final progress = [45, 52, 61, 70, 82, 90];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(progress.length, (index) {
              return Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: progress[index].toDouble() * 1.8,
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Term ${index + 1}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Strong student growth trend over the last six terms.', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: iconColor.withAlpha(30),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...items.map((text) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(25),
                  child: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
