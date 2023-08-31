import 'dart:convert';

import 'package:secure_shared_preferences/secure_shared_preferences.dart';
import 'package:storage_encryption/model/example_model.dart';
import 'package:storage_encryption/services/timer_service.dart';

class SecureSharedPreferenceService {
  SecureSharedPreferenceService();

  Future<void> clearAll() async {
    final prefs = await SecureSharedPref.getInstance();
    await prefs.clearAll();
  }

  Future<void> saveString(String key, String value) async {
    TimerService().captureOption2(
      () async {
        final prefs = await SecureSharedPref.getInstance();
        await prefs.putString(key, value, isEncrypted: true);
      },
    );
  }

  Future<void> saveBool(String key, bool value) async {
    TimerService().captureOption2(
      () async {
        final prefs = await SecureSharedPref.getInstance();
        await prefs.putBool(key, value, isEncrypted: true);
      },
    );
  }

  Future<void> saveInt(String key, int value) async {
    TimerService().captureOption2(
      () async {
        final prefs = await SecureSharedPref.getInstance();
        await prefs.putInt(key, value, isEncrypted: true);
      },
    );
  }

  Future<void> saveStringList(String key, List<String> value) async {
    TimerService().captureOption2(
      () async {
        final prefs = await SecureSharedPref.getInstance();
        await prefs.putStringList(key, value, isEncrypted: true);
      },
    );
  }

  Future<void> saveObject(String key, ExampleModel value) async {
    TimerService().captureOption2(
      () async {
        final prefs = await SecureSharedPref.getInstance();
        await prefs.putString(key, json.encode(value.toJson()),
            isEncrypted: true);
      },
    );
  }

  Future<String?> loadString(String key) async {
    final prefs = await SecureSharedPref.getInstance();
    return prefs.getString(key, isEncrypted: true);
  }

  Future<bool?> loadBool(String key) async {
    final prefs = await SecureSharedPref.getInstance();
    return prefs.getBool(key, isEncrypted: true);
  }

  Future<int?> loadInt(String key) async {
    final prefs = await SecureSharedPref.getInstance();
    return prefs.getInt(key, isEncrypted: true);
  }

  Future<List<String>?> loadStringList(String key) async {
    final prefs = await SecureSharedPref.getInstance();
    return prefs.getStringList(key, isEncrypted: true);
  }

  Future<ExampleModel?> loadObject(String key) async {
    final prefs = await SecureSharedPref.getInstance();
    final jsonString = await prefs.getString(key, isEncrypted: true);

    if (jsonString != null) {
      return ExampleModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
