import 'package:hive_flutter/hive_flutter.dart';
import 'package:storage_encryption/model/example_model.dart';
import 'package:storage_encryption/services/timer_service.dart';

class HiveService {
  static const String box = 'myBox';

  HiveService._();

  static HiveService? _instance;

  factory HiveService() {
    _instance ??= HiveService._();
    return _instance!;
  }

  initCipher({required HiveAesCipher chiper}) async {
    await Hive.openBox(box, encryptionCipher: chiper);
  }

  Future<void> write(String key, dynamic data) async {
    TimerService().captureOption4(
      () async {
        final myBox = await Hive.openBox(box);
        await myBox.put('hive_$key', data);
        await myBox.close();
      },
    );
  }

  Future<void> delete(String key) async {
    final myBox = await Hive.openBox(box);
    await myBox.delete('hive_$key');
    await myBox.close();
  }

  Future<void> deleteAll() async {
    final myBox = await Hive.openBox(box);
    await myBox.deleteFromDisk();
    await myBox.close();
  }

  Future<dynamic> read(String key) async {
    final myBox = await Hive.openBox(box);
    return myBox.get('hive_$key', defaultValue: null);
  }

  Future<String?> loadString(String key) async {
    return read(key) as String?;
  }

  Future<bool?> loadBool(String key) async {
    return read(key) as bool?;
  }

  Future<int?> loadInt(String key) async {
    return read(key) as int?;
  }

  Future<List<String>?> loadStringList(String key) async {
    return read(key) as List<String>?;
  }

  Future<ExampleModel?> loadObject(String key) async {
    return read(key) as ExampleModel?;
  }
}
