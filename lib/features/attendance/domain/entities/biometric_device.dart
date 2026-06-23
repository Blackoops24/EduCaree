class BiometricDevice {
  final int id;
  final String deviceName;
  final String deviceType; // ZKTeco, eSSL
  final String deviceSerialNumber;
  final String ipAddress;
  final int port;
  final String location;
  final bool isActive;
  final DateTime lastSyncTime;
  final String? apiKey;
  final String? apiSecret;

  const BiometricDevice({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.deviceSerialNumber,
    required this.ipAddress,
    required this.port,
    required this.location,
    required this.isActive,
    required this.lastSyncTime,
    this.apiKey,
    this.apiSecret,
  });
}
