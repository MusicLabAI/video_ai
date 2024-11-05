import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

class Rsa {
  static Future<String> encodeString(String? content) async {
    if (content == null) return '';
    const public = '''
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAonhPf4y4kKYMc2QQaw3pF4TZ3RDWMT86ISqOcSOdyTTIvPNkqF2RMc4hlNiGypG2vmUo0rU9AbnEBaKhC7GjWZEh7kn95xHzlWB5F6Mfkpy0up15nr+/h8qFt0Sgr+cVh5kgYrB8lv2n8EINNjseyQFNthPsaxABImKTL/d6rVYsPRtjAbkpv+ZhZRZfGtdUHkJXhpoPgPpOoLYmnvQQXz0NERdyFS0ouojiBi/9MU882lrkKGbE0/yoiz7Bmg52lVPtHDM5Arr0hndeYbaEr1tQ5RZRL5jysAKK1zJSxyRAXw7eG3G9yIHO4JgBAxOJcXPowFfvSCcfEZd3YZkQtwIDAQAB
-----END PUBLIC KEY-----
''';
    dynamic publicKey = RSAKeyParser().parse(public);
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(content).base64;
  }
}
