import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_des/dart_des.dart';

class DesUtil {

  static String desEncrypt(String plaintext, String key, int time) {
    final byteBuffer = ByteData(8);
    byteBuffer.setInt64(0, time, Endian.big);
    final iv = byteBuffer.buffer.asUint8List();
    DES3 des3CBC = DES3(key: key.codeUnits, mode: DESMode.CBC, iv: iv, paddingType: DESPaddingType.PKCS5);
    final encrypted = des3CBC.encrypt(plaintext.codeUnits);
    /**
     * 
    print('encrypted (hex): ${hex.encode(encrypted)}');
    print('encrypted (base64): ${base64.encode(encrypted)}');
    print('decrypted (hex): ${hex.encode(decrypted)}');
    final decrypted = des3CBC.decrypt(encrypted);
    print('decrypted (utf8): ${utf8.decode(decrypted)}');
     */
    return base64.encode(encrypted);
  }

}
