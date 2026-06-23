import 'package:flutter/widgets.dart';

class StaffKeys {
  static const Key staffManagementPage = Key('staffManagementPage');
  static const Key registrationPage = Key('registrationPage');
  static const Key profilePage = Key('profilePage');
  static const Key leavePage = Key('leavePage');
  static const Key attendancePage = Key('attendancePage');
  static const Key performancePage = Key('performancePage');
  static const Key salaryPage = Key('salaryPage');

  static const Key registerStaffButton = Key('registerStaffButton');
  static const Key staffListView = Key('staffListView');
  static const Key staffInfoCard = Key('staffInfoCard');
  static const Key leaveListView = Key('leaveListView');
  static const Key attendanceListView = Key('attendanceListView');
  static const Key performanceListView = Key('performanceListView');
  static const Key salaryInfoCard = Key('salaryInfoCard');

  static Key staffTile(int id) => Key('staffTile_$id');
}
