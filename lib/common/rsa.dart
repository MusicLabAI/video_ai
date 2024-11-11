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

  static Future<String> decodeString(String? content) async {
    if (content == null) return '';
    // final private = await rootBundle.loadString('keys/buy_private_key.pem');
    const private  = '''
-----BEGIN PRIVATE KEY-----
MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIA3So5iLUkyakI8L0ZQA7CeXODT9qBxx33Rv2a8jc2qy+UHBxeb87cl/lm1DufnAA0DGXUTL7iGdjT7NCguUTXuxHRHSOHszccKyDzabNZ87sxZ7TkbA5gdGkFSDmUpHgMxauh1nplAnUi+29O/QGaezHrdveIQbdyOp8XlhN+ZAgMBAAECgYAMbE8PCLg2lWnyTP6Po4UYAeAh8Ke+2AdqS35uJ+rdeKUU5d9sDDJLFqVUb9Sn55v7psc6rsc669xcOdLN6d74ZVwOZ2yI/6mk+oDsxt0nASNLW/DQm54WRgmmJnUEcUDO4JiCBY2bXkeZKhYK6VRxzoMewolsQ9Ae/uY7QiAQAQJBANBnnN8ruDsM6wtIUNfFhXZifviW5ggUi5xc0I8VRQAeNwhuynKEOUhf7o1Zk0RLHQ4DhzGvTcykVxXuii1sapkCQQCdf3Dyb99D1C9IZJ4MvDR4i/Wviozy5UwIxAtn0HOujXWByH07zQN94pXfTFnSykQLThnnjfEuZ5qi1/Jpgj0BAkAK86b2w2FnGQKxERfOfv7IfdyWS7fC7PF5QhdjrYZ2vx+9PbU911z7RK9Qlkh66keYmO7d2YyJGInLCUIRqQThAkBzJXtEJDpM8tJm0PkkQmzyPREwd9E4vB9swTe9fI827MEeU6ALmoWVAZWlHcMF807wHPefbQ0JakGKEOtv7AIBAkBpikI69QPsVB6YcH8AaJM8DGIHx32gDV0fquUykhpMa64cFWlr/907N5AEQZrxruziCZvwJpQM0AMOAuG05unV
-----END PRIVATE KEY-----
''';
    dynamic privateKey = RSAKeyParser().parse(private);

    final encrypter = Encrypter(RSA(privateKey: privateKey));

    return encrypter.decrypt(Encrypted.fromBase64(content)).toString();
  }
}
