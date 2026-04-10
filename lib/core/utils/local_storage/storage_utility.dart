import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  final _storage = GetStorage();
  final _secureStorage = FlutterSecureStorage();

  Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  dynamic readData(String key) {
    return _storage.read(key);
  }

  Future<void> deleteData(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearStorage() async {
    await _storage.erase();
  }

  Future<void> saveSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  Future<void> clearData() async {
    await _secureStorage.deleteAll();
  }
}
