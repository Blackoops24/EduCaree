import 'package:educare/core/services/module_persistence_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('module state survives a local reload without the API', () async {
    SharedPreferences.setMockInitialValues({});
    final service = ModulePersistenceService.instance
      ..enabled = true
      ..remoteEnabled = false;
    addTearDown(() {
      service
        ..enabled = true
        ..remoteEnabled = true;
    });

    final state = {
      'students': [
        {'admissionNo': 'edu202699', 'name': 'Persisted Student'},
      ],
    };

    await service.save('students', state);
    final reloaded = await service.load('students');

    expect(reloaded, state);
  });
}
