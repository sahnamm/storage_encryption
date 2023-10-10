import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:storage_encryption/services/timer_service.dart';

class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;

  late FlutterSecureStorage storage;

  init() async {
    storage = const FlutterSecureStorage();
  }

  Future<void> write(String key, String dataToEncrypt) async {
    TimerService().captureOption3(
      () async {
        await storage.write(key: "secure_storage_$key", value: dataToEncrypt);
      },
    );
  }

  Future<void> delete(String key) async {
    return await storage.delete(key: "secure_strorage_$key");
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll();
  }

  Future<String?> read(String key) async {
    return await storage.read(key: "secure_storage_$key");
  }
}
