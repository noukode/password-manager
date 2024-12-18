import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final EncryptionHelper instance = EncryptionHelper._internal();
  factory EncryptionHelper() => instance;
  EncryptionHelper._internal();

  String encrypt(String encryptKey,String plainText) {
    final key = Key.fromUtf8(encryptKey.substring(0, 16));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(encryptKey.substring(0, 16));
    Encrypted encryptedString = encrypter.encrypt(plainText, iv: initVector);
    return encryptedString.base64;
  }

  String decrypt(String encryptKey, String encryptedString) {
    final key = Key.fromUtf8(encryptKey.substring(0, 16));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(encryptKey.substring(0, 16));
    Encrypted encryptedData = Encrypted.fromBase64(encryptedString);
    return encrypter.decrypt(encryptedData, iv: initVector);
  }
}