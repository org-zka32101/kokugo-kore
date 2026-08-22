import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: web/iOSアプリを「kore1」プロジェクトに登録し、正しい値に更新すること。
  // 現状は旧プロジェクト（petit-works-education）の値のまま残っている。
  // Androidと違いこの2つはまだ利用されていないため緊急ではないが、
  // Firebase Web SDK/iOSでこのアプリを動かす前に必ず修正が必要。
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCBwPBEXptIW_8wl0_hWtZhpSJcuod00Eg',
    appId: '1:492221061005:web:0c9d94f157252096c88fc4',
    messagingSenderId: '492221061005',
    projectId: 'petit-works-education',
    storageBucket: 'petit-works-education.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjpHo46GeJzN_TMINl1eaMNJet3QFXr_U',
    appId: '1:906257233334:android:2e17f224a0f8a7e41ffd17',
    messagingSenderId: '906257233334',
    projectId: 'kore1-6b58e',
    storageBucket: 'kore1-6b58e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBwPBEXptIW_8wl0_hWtZhpSJcuod00Eg',
    appId: '1:492221061005:ios:0c9d94f157252096c88fc4',
    messagingSenderId: '492221061005',
    projectId: 'petit-works-education',
    storageBucket: 'petit-works-education.firebasestorage.app',
    iosBundleId: 'com.yourwish.shougakukore.kokugo',
  );
}
