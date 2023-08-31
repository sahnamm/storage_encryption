import 'package:encrypt/encrypt.dart';

class EncryptService {
  EncryptService._();
  static final EncryptService _instance = EncryptService._();
  factory EncryptService() => _instance;

  final dummySecret = "1234567890abcdefghijklmnopqrstuv";
  late Encrypter encrypter;
  final iv = IV.fromLength(16);

  init() {
    encrypter = getEncrypter();
  }

  getEncrypter() {
    return Encrypter(AES(Key.fromUtf8(dummySecret), mode: AESMode.ecb));
  }

  Future<String> encrypt(String dataToEncrypt) async {
    final encryptedData = encrypter.encrypt(dataToEncrypt, iv: iv);
    return encryptedData.base64;
  }

  Future<String> decrypt(String encryptedData) async {
    final data = encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: iv);
    return data;
  }
}
