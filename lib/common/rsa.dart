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
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDCBcddzp2++fdVErz6yF8DiHNxQgPGjmrQQyzFWxZNXhhNdZ5jJb2CXFhFLbtPaxtvG/t+SIa3fMoxSEHqehBn9tcO5yEC6kay7361NzJO1N1Cl50oaZSR/3MJ3RInfCwBT1ZNQtXR2wUKmImYOmscLsxKwTvJrP1NqP2ao/hgg7EdwfEJj9pdfhlaP/bM4nYlkGUDCBQdoYj/wvZ6FO8LUsFZJhNx4IdRsZdw7uiIXSAnQs+ugKUVmh7LTsAEdHtJYsFggwUJ8tkyegqM5ludRmsJlzKae6mCyZTbHyEozQjSdQsrtDmIFqRHRa2dHfiQTZmw92L+M0qdHhtTd20jAgMBAAECggEBAK1evowbMSfScujI6qbo3sXoasd8ZqVI4zcfn2TmhKIzf2HPxOzxb0qKO7HtMF/B5Gy/Q1XPdtmEn6Oz3nqoAfr0Pa0qaHwTXYNMsBs7rC921BNKKPtQhJqE+YWJzkwMD8JH42T8YNW5cOLL9L9bDBTN2GzACC2o71sysxI4jJun4bABvSUmS6KucHe5pDqnb3Q7HGWTJfrYATP6XrY33ilXrDVA0YRW3hByiSExwP4brRYbbzNiNr1rcqdKixVlXqPWXp+ClZUGMs4gOxNOM8xVwILp6dvR5ubPbT9+B0zwZbtAA7HhK/lc2P41MQu92ix/NJJpfNcjoW6nhVPomNECgYEA8kaXVvw5A88g3vBUHwZmgKM/92HR2XvcyhzZ2p9HVUvfKO05Gwthx7TRdpuya4Q2I40akYpysG8vChxUyOuhl4EgCHP26M2qyy2MxFoI7hc0uPykrtLpVBvkUnTzVH6LQwAkfczEALY1Bq8t6KBQK+svay9k95L/OzHpNCe38wsCgYEAzQNvUR5KPYgQgwuxYOUrV/GcP9SvGU7T9DSsPKSQMlobiIXRaLDPIUr1o0+DJguudX9KwAYIlj+40ax72rDv7xYJ2xIF+pXWUUudL/DkrgFoq/eGasRXlOvWCrlSBCBl90YK8eYIHyOmtB2q+7yRwu4ShuQYxuBzFy1NSZE8vUkCgYEApWAYJ/Es/fOh7WvBEBhvWXmVzUhBVSIeWPwOnRPCPm/22VnsdBB14zsDC+JFjOyHhAbqTtRhaxvJ0S37ldZ5zBABDKQTs1/IKL5j6xfGJrdCbs9NnmQrjxUm6j4YZuGmL8rmHdTrKc02LuTfAn6DmycDjDeixPfbLs3n8Ij4IHcCgYBRJhvo2vl98569kGJMvUlzzRIQ/gm1Fcu17SeD9YuSMrKVToq+SsYiIn6qfu2loJgUsCcRbRH3DxAEBqcbwE+ormuGSFMPhkHH+gslD9AkxC//acHN/xu/ub4GjqZVNdHGl/X7HBd44+63esrUTCbSJtQ0ipL4HZ3QvcDK7u9A6QKBgQDdgeb5M6X3fJHdIPW7WbkLl9ziIYGY/Mi9Ng+iHXaQaMgS2uMQ4lE8F46h75DjID7MMk2ArpS5FtgwZa71+Poubu7ErEgRdEjP+ixzWhmv4SD2fyNVASlg4RmGMgl+rKtCD7xI/IRQlNzHuTbbuOFxR3SFGQ7Us15sYMq/5/lDJw==
-----END PRIVATE KEY-----
''';
    dynamic privateKey = RSAKeyParser().parse(private);

    final encrypter = Encrypter(RSA(privateKey: privateKey));

    return encrypter.decrypt(Encrypted.fromBase64(content)).toString();
  }
}
