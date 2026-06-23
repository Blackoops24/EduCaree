import 'package:educare/features/attendance/domain/entities/biometric_device.dart';
import 'package:educare/features/attendance/domain/repositories/attendance_repository.dart';

class FetchBiometricDevicesUseCase {
  final AttendanceRepository _repository;

  FetchBiometricDevicesUseCase(this._repository);

  Future<List<BiometricDevice>> execute() {
    return _repository.fetchBiometricDevices();
  }
}
