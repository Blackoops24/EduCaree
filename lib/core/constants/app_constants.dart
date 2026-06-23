class AppRoutes {
  static const String login = '/';
  static const String dashboard = '/dashboard';

  static const String students = '/students';
  static const String studentsAdmission = '/students/admission';
  static const String studentsProfile = '/students/:id';
  static const String studentsDocuments = '/students/:id/documents';
  static const String studentsTransfer = '/students/:id/transfer-certificate';
  static const String studentsAlumni = '/students/alumni';

  static const String staff = '/staff';
  static const String staffRegistration = '/staff/register';
  static const String staffProfile = '/staff/:id';
  static const String staffLeave = '/staff/:id/leaves';
  static const String staffAttendance = '/staff/:id/attendance';
  static const String staffPerformance = '/staff/:id/performance';
  static const String staffSalary = '/staff/:id/salary';

  static const String academics = '/academics';
  static const String classManagement = '/academics/classes';
  static const String timetable = '/academics/timetable/:sectionId';
  static const String marksEntry = '/academics/marks/:examId/:sectionId';
  static const String reportCard = '/academics/report-card/:studentId/:classId';

  static const String attendance = '/attendance';
  static const String studentAttendanceDaily = '/attendance/students/daily';
  static const String staffDailyAttendance = '/attendance/staff';
  static const String biometricIntegration = '/attendance/biometric';
  static const String faceRecognition = '/attendance/face-recognition';

  static const String fees = '/fees';
  static const String transport = '/transport';
  static const String inventory = '/inventory';
  static const String notifications = '/notifications';
  static const String library = '/library';
  static const String profileAccessControl = '/profile-access-control';

  static const String loginName = 'login';
  static const String dashboardName = 'dashboard';
  static const String studentsName = 'students';
  static const String studentsAdmissionName = 'students_admission';
  static const String studentsProfileName = 'students_profile';
  static const String studentsDocumentsName = 'students_documents';
  static const String studentsTransferName = 'students_transfer';
  static const String studentsAlumniName = 'students_alumni';
  static const String staffName = 'staff';
  static const String staffRegistrationName = 'staff_registration';
  static const String staffProfileName = 'staff_profile';
  static const String staffLeaveName = 'staff_leaves';
  static const String staffAttendanceName = 'staff_attendance';
  static const String staffPerformanceName = 'staff_performance';
  static const String staffSalaryName = 'staff_salary';
  static const String academicsName = 'academics';
  static const String classManagementName = 'class_management';
  static const String timetableName = 'timetable';
  static const String marksEntryName = 'marks_entry';
  static const String reportCardName = 'report_card';
  static const String attendanceName = 'attendance';
  static const String studentAttendanceDailyName = 'student_attendance_daily';
  static const String staffDailyAttendanceName = 'staff_daily_attendance';
  static const String biometricIntegrationName = 'biometric_integration';
  static const String feesName = 'fees';
  static const String transportName = 'transport';
  static const String inventoryName = 'inventory';
  static const String notificationsName = 'notifications';
  static const String libraryName = 'library';
  static const String faceRecognitionName = 'face_recognition';
  static const String profileAccessControlName = 'profile_access_control';

  static String studentsProfileRoute(int id) => '/students/$id';
  static String studentsDocumentsRoute(int id) => '/students/$id/documents';
  static String studentsTransferRoute(int id) => '/students/$id/transfer-certificate';

  static String staffProfileRoute(int id) => '/staff/$id';
  static String staffLeaveRoute(int id) => '/staff/$id/leaves';
  static String staffAttendanceRoute(int id) => '/staff/$id/attendance';
  static String staffPerformanceRoute(int id) => '/staff/$id/performance';
  static String staffSalaryRoute(int id) => '/staff/$id/salary';

  static String timetableRoute(int sectionId) => '/academics/timetable/$sectionId';
  static String marksEntryRoute(int examId, int sectionId) => '/academics/marks/$examId/$sectionId';
  static String reportCardRoute(int studentId, int classId) => '/academics/report-card/$studentId/$classId';
}
