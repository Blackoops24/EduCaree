import 'package:flutter/widgets.dart';

class StudentKeys {
  static const Key studentManagementPage = Key('studentManagementPage');
  static const Key admissionPage = Key('admissionPage');
  static const Key studentProfilePage = Key('studentProfilePage');
  static const Key documentsPage = Key('documentsPage');
  static const Key transferCertificatePage = Key('transferCertificatePage');
  static const Key alumniPage = Key('alumniPage');

  static const Key admissionForm = Key('admissionForm');
  static const Key admissionSubmitButton = Key('admissionSubmitButton');
  static const Key studentListView = Key('studentListView');
  static const Key studentInfoCard = Key('studentInfoCard');
  static const Key documentListView = Key('documentListView');
  static const Key transferForm = Key('transferForm');
  static const Key alumniListView = Key('alumniListView');

  static Key studentTile(int id) => Key('studentTile_$id');
}
