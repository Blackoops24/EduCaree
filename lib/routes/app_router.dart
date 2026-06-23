import 'package:go_router/go_router.dart';
import 'package:educare/core/constants/app_constants.dart';
import 'package:educare/core/widgets/app_shell.dart';
import 'package:educare/features/academics/presentation/pages/academic_management_page.dart';
import 'package:educare/features/academics/presentation/pages/class_management_page.dart';
import 'package:educare/features/academics/presentation/pages/marks_entry_page.dart';
import 'package:educare/features/academics/presentation/pages/report_card_page.dart';
import 'package:educare/features/academics/presentation/pages/timetable_view_page.dart';
import 'package:educare/features/attendance/presentation/pages/attendance_management_page.dart';
import 'package:educare/features/attendance/presentation/pages/biometric_integration_page.dart';
import 'package:educare/features/attendance/presentation/pages/face_recognition_page.dart';
import 'package:educare/features/attendance/presentation/pages/staff_attendance_page.dart';
import 'package:educare/features/attendance/presentation/pages/student_daily_attendance_page.dart';
import 'package:educare/features/fees/presentation/pages/fee_management_page.dart';
import 'package:educare/features/library/presentation/pages/library_management_page.dart';
import 'package:educare/features/notifications/presentation/pages/notification_management_page.dart';
import 'package:educare/features/transport/presentation/pages/transport_management_page.dart';
import 'package:educare/features/inventory/presentation/pages/inventory_management_page.dart';
import 'package:educare/features/messages/presentation/pages/message_center_page.dart';
import 'package:educare/features/calendar/presentation/pages/calendar_overview_page.dart';
import 'package:educare/features/authentication/presentation/pages/login_page.dart';
import 'package:educare/features/authentication/presentation/pages/registration_page.dart';
import 'package:educare/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:educare/features/students/presentation/pages/admission_page.dart';
import 'package:educare/features/students/presentation/pages/alumni_page.dart';
import 'package:educare/features/students/presentation/pages/documents_page.dart';
import 'package:educare/features/students/presentation/pages/student_management_page.dart';
import 'package:educare/features/students/presentation/pages/student_profile_page.dart';
import 'package:educare/features/students/presentation/pages/transfer_certificate_page.dart';
import 'package:educare/features/staff/presentation/pages/attendance_page.dart';
import 'package:educare/features/staff/presentation/pages/leave_management_page.dart';
import 'package:educare/features/staff/presentation/pages/performance_page.dart';
import 'package:educare/features/staff/presentation/pages/salary_details_page.dart';
import 'package:educare/features/staff/presentation/pages/staff_management_page.dart';
import 'package:educare/features/staff/presentation/pages/staff_profile_page.dart';
import 'package:educare/features/staff/presentation/pages/staff_registration_page.dart';
import 'package:educare/features/settings/presentation/pages/profile_access_control_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.registration,
      name: AppRoutes.registrationName,
      builder: (context, state) => const RegistrationPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(
        location: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: AppRoutes.dashboardName,
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: AppRoutes.students,
          name: AppRoutes.studentsName,
          builder: (context, state) => const StudentManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.staff,
          name: AppRoutes.staffName,
          builder: (context, state) => const StaffManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.staffRegistration,
          name: AppRoutes.staffRegistrationName,
          builder: (context, state) => const StaffRegistrationPage(),
        ),
        GoRoute(
          path: AppRoutes.staffProfile,
          name: AppRoutes.staffProfileName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return StaffProfilePage(staffId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.staffLeave,
          name: AppRoutes.staffLeaveName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return LeaveManagementPage(staffId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.staffAttendance,
          name: AppRoutes.staffAttendanceName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return AttendancePage(staffId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.staffPerformance,
          name: AppRoutes.staffPerformanceName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return PerformancePage(staffId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.staffSalary,
          name: AppRoutes.staffSalaryName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return SalaryDetailsPage(staffId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.studentsAdmission,
          name: AppRoutes.studentsAdmissionName,
          builder: (context, state) => const AdmissionPage(),
        ),
        GoRoute(
          path: AppRoutes.studentsProfile,
          name: AppRoutes.studentsProfileName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return StudentProfilePage(studentId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.studentsDocuments,
          name: AppRoutes.studentsDocumentsName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return DocumentsPage(studentId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.studentsTransfer,
          name: AppRoutes.studentsTransferName,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return TransferCertificatePage(studentId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.studentsAlumni,
          name: AppRoutes.studentsAlumniName,
          builder: (context, state) => const AlumniPage(),
        ),
        GoRoute(
          path: AppRoutes.academics,
          name: AppRoutes.academicsName,
          builder: (context, state) => const AcademicManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.classManagement,
          name: AppRoutes.classManagementName,
          builder: (context, state) => const ClassManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.timetable,
          name: AppRoutes.timetableName,
          builder: (context, state) {
            final sectionId = int.parse(state.pathParameters['sectionId']!);
            return TimetableViewPage(sectionId: sectionId);
          },
        ),
        GoRoute(
          path: AppRoutes.marksEntry,
          name: AppRoutes.marksEntryName,
          builder: (context, state) {
            final examId = int.parse(state.pathParameters['examId']!);
            final sectionId = int.parse(state.pathParameters['sectionId']!);
            return MarksEntryPage(examId: examId, sectionId: sectionId);
          },
        ),
        GoRoute(
          path: AppRoutes.reportCard,
          name: AppRoutes.reportCardName,
          builder: (context, state) {
            final studentId = int.parse(state.pathParameters['studentId']!);
            final classId = int.parse(state.pathParameters['classId']!);
            return ReportCardPage(studentId: studentId, classId: classId);
          },
        ),
        GoRoute(
          path: AppRoutes.attendance,
          name: AppRoutes.attendanceName,
          builder: (context, state) => const AttendanceManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.fees,
          name: AppRoutes.feesName,
          builder: (context, state) => const FeeManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.transport,
          name: AppRoutes.transportName,
          builder: (context, state) => const TransportManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.inventory,
          name: AppRoutes.inventoryName,
          builder: (context, state) => const InventoryManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          name: AppRoutes.notificationsName,
          builder: (context, state) => const NotificationManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.messages,
          name: AppRoutes.messagesName,
          builder: (context, state) => const MessageCenterPage(),
        ),
        GoRoute(
          path: AppRoutes.calendar,
          name: AppRoutes.calendarName,
          builder: (context, state) => const CalendarOverviewPage(),
        ),
        GoRoute(
          path: AppRoutes.library,
          name: AppRoutes.libraryName,
          builder: (context, state) => const LibraryManagementPage(),
        ),
        GoRoute(
          path: AppRoutes.studentAttendanceDaily,
          name: AppRoutes.studentAttendanceDailyName,
          builder: (context, state) => const StudentDailyAttendancePage(),
        ),
        GoRoute(
          path: AppRoutes.staffDailyAttendance,
          name: AppRoutes.staffDailyAttendanceName,
          builder: (context, state) => const StaffAttendancePage(),
        ),
        GoRoute(
          path: AppRoutes.biometricIntegration,
          name: AppRoutes.biometricIntegrationName,
          builder: (context, state) => const BiometricIntegrationPage(),
        ),
        GoRoute(
          path: AppRoutes.faceRecognition,
          name: AppRoutes.faceRecognitionName,
          builder: (context, state) => const FaceRecognitionPage(),
        ),
        GoRoute(
          path: AppRoutes.profileAccessControl,
          name: AppRoutes.profileAccessControlName,
          builder: (context, state) => const ProfileAccessControlPage(),
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);
