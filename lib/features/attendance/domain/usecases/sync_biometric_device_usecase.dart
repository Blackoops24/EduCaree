import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class SyncBiometricDeviceUseCase {
  final AttendanceRepository _repository;

  SyncBiometricDeviceUseCase(this._repository);

  Future<bool> execute(int deviceId) {
    return _repository.syncBiometricDevice(deviceId);
  }
}
