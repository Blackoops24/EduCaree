import 'package:educare/features/attendance/domain/entities/biometric_device.dart';

class BiometricDeviceModel extends BiometricDevice {
  const BiometricDeviceModel({
    required super.id,
    required super.deviceName,
    required super.deviceType,
    required super.deviceSerialNumber,
    required super.ipAddress,
    required super.port,
    required super.location,
    required super.isActive,
    required super.lastSyncTime,
    super.apiKey,
    super.apiSecret,
  });

  factory BiometricDeviceModel.fromJson(Map<String, dynamic> json) {
    return BiometricDeviceModel(
      id: json['id'] as int,
      deviceName: json['device_name'] as String,
      deviceType: json['device_type'] as String,
      deviceSerialNumber: json['device_serial_number'] as String,
      ipAddress: json['ip_address'] as String,
      port: json['port'] as int,
      location: json['location'] as String,
      isActive: json['is_active'] as bool,
      lastSyncTime: DateTime.parse(json['last_sync_time'] as String),
      apiKey: json['api_key'] as String?,
      apiSecret: json['api_secret'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': deviceName,
      'device_type': deviceType,
      'device_serial_number': deviceSerialNumber,
      'ip_address': ipAddress,
      'port': port,
      'location': location,
      'is_active': isActive,
      'last_sync_time': lastSyncTime.toIso8601String(),
      'api_key': apiKey,
      'api_secret': apiSecret,
    };
  }
}
