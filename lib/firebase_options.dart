// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1z6x4YREas4K3xEEiEj-yfBj3s1Y6Yw0',
    appId: '1:127411722371:web:b3e73ca0d50dbcac20e3b6',
    messagingSenderId: '127411722371',
    projectId: 'testfirebase-65da8',
    authDomain: 'testfirebase-65da8.firebaseapp.com',
    databaseURL: 'https://testfirebase-65da8.firebaseio.com',
    storageBucket: 'testfirebase-65da8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD87R0_VA-7u6hxKN3VhCQhCaNjd_gznn8',
    appId: '1:127411722371:android:de0a563a157bd77f20e3b6',
    messagingSenderId: '127411722371',
    projectId: 'testfirebase-65da8',
    databaseURL: 'https://testfirebase-65da8.firebaseio.com',
    storageBucket: 'testfirebase-65da8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbqPdA6-nIm_EE5qlHCgMKH9vpeEnPp7I',
    appId: '1:127411722371:ios:df08410745f083df20e3b6',
    messagingSenderId: '127411722371',
    projectId: 'testfirebase-65da8',
    databaseURL: 'https://testfirebase-65da8.firebaseio.com',
    storageBucket: 'testfirebase-65da8.appspot.com',
    iosClientId: '127411722371-i2i3frkv3atf89vth9bsn6tsrbe0n5c0.apps.googleusercontent.com',
    iosBundleId: 'io.terabits.fltBootstrap',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbqPdA6-nIm_EE5qlHCgMKH9vpeEnPp7I',
    appId: '1:127411722371:ios:df08410745f083df20e3b6',
    messagingSenderId: '127411722371',
    projectId: 'testfirebase-65da8',
    databaseURL: 'https://testfirebase-65da8.firebaseio.com',
    storageBucket: 'testfirebase-65da8.appspot.com',
    iosClientId: '127411722371-i2i3frkv3atf89vth9bsn6tsrbe0n5c0.apps.googleusercontent.com',
    iosBundleId: 'io.terabits.fltBootstrap',
  );
}
