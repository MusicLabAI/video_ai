import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import '../api/request.dart';

class AwsUtils {
  static const String bucketName = 'sunomuisc-link';
  static const String region = 'us-east-1';
  static String sessionToken = '';
  static String accessKeyId = '';
  static String secretAccessKey = '';

  static Future<String> uploadByFile(File file) async {
    try {
      if (accessKeyId.isEmpty) {
      }
      final tokenRes = await Request.getUploadToken();
      accessKeyId = tokenRes['accessKeyId'];
      secretAccessKey = tokenRes['secretAccessKey'];
      sessionToken = tokenRes['sessionToken'];

      final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      final length = await file.length();

      final uri = Uri.parse('https://$bucketName.s3.$region.amazonaws.com');
      final req = http.MultipartRequest("POST", uri);
      final multipartFile = http.MultipartFile('file', stream, length, filename: path.basename(file.path));

      final policy = Policy.fromS3PresignedPost(
        'luma/image/${DateTime.now().microsecondsSinceEpoch}.jpg',
        bucketName,
        15,
        accessKeyId,
        length,
        sessionToken,
        region: region,
        contentType: 'image/jpeg',
      );
      final key = SigV4.calculateSigningKey(secretAccessKey, policy.datetime, region, 's3');
      final signature = SigV4.calculateSignature(key, policy.encode());

      req.files.add(multipartFile);
      req.fields['key'] = policy.key;
      req.fields['acl'] = 'public-read';
      req.fields['X-Amz-Credential'] = policy.credential;
      req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
      req.fields['X-Amz-Date'] = policy.datetime;
      req.fields['Policy'] = policy.encode();
      req.fields['X-Amz-Signature'] = signature;
      req.fields['x-amz-security-token'] = sessionToken;
      req.fields['Content-Type'] = policy.contentType;

      final res = await req.send();
      if (res.statusCode == 200 || res.statusCode == 204) {
        return 'https://s.sunomusic.ai/${policy.key}';
      } else {
        throw res.toString();
      }
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: e.toString());
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  String sessionToken;
  int maxFileSize;
  String contentType;

  Policy(
    this.key,
    this.bucket,
    this.datetime,
    this.expiration,
    this.credential,
    this.maxFileSize,
    this.sessionToken, {
    this.region = 'us-east-1',
    this.contentType = 'image/jpeg',
  });

  factory Policy.fromS3PresignedPost(
    String key,
    String bucket,
    int expiryMinutes,
    String accessKeyId,
    int maxFileSize,
    String sessionToken, {
    String region = 'us-east-1',
    String contentType = 'image/jpeg',
  }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now()).add(Duration(minutes: expiryMinutes)).toUtc().toString().split(' ').join('T');
    final cred = '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';
    final p = Policy(key, bucket, datetime, expiration, cred, maxFileSize, sessionToken, region: region);
    return p;
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "$expiration",
  "conditions": [
    {"bucket": "$bucket"},
    ["starts-with", "\$key", "$key"],
    {"acl": "public-read"},
    ["content-length-range", 1, $maxFileSize],
    {"x-amz-credential": "$credential"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" },
    {"x-amz-security-token": "$sessionToken" },
    {"Content-Type": "$contentType" }
  ]
}
''';
  }
}
