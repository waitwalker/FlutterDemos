import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';

const String _keyString = '3dd19414e91ac01b';
const  String _ivString = '2624b9a9c447e587';
class EncryptUtil {

  static final _key = encrypt.Key.fromUtf8(_keyString);
  static final _iv = encrypt.IV.fromUtf8(_ivString);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

  /// encrypt
  static Uint8List aesEncrypt(Uint8List data) {
    encrypt.Encrypted encrypted = _encrypter.encryptBytes(data, iv: _iv);
    return Uint8List.fromList(encrypted.bytes);
  }

  /// decrypt
  static Uint8List aesDecrypt(Uint8List data){
    List<int> decryptData = _encrypter.decryptBytes(Encrypted(data), iv: _iv);
    return Uint8List.fromList(decryptData);
  }
}