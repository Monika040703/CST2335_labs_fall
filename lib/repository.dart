import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Load user data from EncryptedSharedPreferences
  Future<Map<String, String?>> loadData() async {
    return {
      'firstName': await _storage.read(key: 'firstName'),
      'lastName': await _storage.read(key: 'lastName'),
      'phone': await _storage.read(key: 'phone'),
      'email': await _storage.read(key: 'email'),
    };
  }

  // Save user data to EncryptedSharedPreferences
  Future<void> saveData(String firstName, String lastName, String phone, String email) async {
    await _storage.write(key: 'firstName', value: firstName);
    await _storage.write(key: 'lastName', value: lastName);
    await _storage.write(key: 'phone', value: phone);
    await _storage.write(key: 'email', value: email);
  }
}
