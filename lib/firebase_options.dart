// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kDebugMode, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for windows - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return kDebugMode ? ios_develop : ios_product;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALDX3TkD2qVQzVLpxa_DfVFRGawB8zeNE',
    appId: '1:378344217481:android:b29f2cf44b72a18e4c1f58',
    messagingSenderId: '378344217481',
    projectId: 'videoai-d0e0e',
    storageBucket: 'videoai-d0e0e.firebasestorage.app',
  );

  static const FirebaseOptions ios_develop = FirebaseOptions(
    apiKey: 'AIzaSyDzB8dylk7ktXmFnlnqaoHGBTuL6fb6zVc',
    appId: '1:995022746616:ios:30331dbbd9f3e2cb8d9c0d',
    messagingSenderId: '995022746616',
    projectId: 'videoai-ios',
    storageBucket: 'videoai-ios.firebasestorage.app',
    iosBundleId: 'luma.sora.pika.runway.video.ai',
  );

  static const FirebaseOptions ios_product = FirebaseOptions(
    apiKey: 'AIzaSyDzB8dylk7ktXmFnlnqaoHGBTuL6fb6zVc',
    appId: '1:995022746616:ios:30331dbbd9f3e2cb8d9c0d',
    messagingSenderId: '995022746616',
    projectId: 'videoai-ios',
    storageBucket: 'videoai-ios.firebasestorage.app',
    iosBundleId: 'luma.sora.pika.runway.video.ai',
  );
}