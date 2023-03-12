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
    apiKey: 'AIzaSyCzz_a4FbqTiw7cermcv2cyBPrV2NelKT8',
    appId: '1:213146812952:web:68fefd22a6e193f275f96d',
    messagingSenderId: '213146812952',
    projectId: 'project-valinity',
    authDomain: 'project-valinity.firebaseapp.com',
    storageBucket: 'project-valinity.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTdCWcQ77POkYNE4cr8-9Epl32IHG0zlU',
    appId: '1:213146812952:android:cf797433b6d5048775f96d',
    messagingSenderId: '213146812952',
    projectId: 'project-valinity',
    storageBucket: 'project-valinity.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6jJ22J3-uT30bHGD6wg5iKR9XPq7XnU8',
    appId: '1:213146812952:ios:0868e81fb43f9ec275f96d',
    messagingSenderId: '213146812952',
    projectId: 'project-valinity',
    storageBucket: 'project-valinity.appspot.com',
    iosClientId: '213146812952-lkecg8m2koa4ootflqkvi0boajnot7vp.apps.googleusercontent.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6jJ22J3-uT30bHGD6wg5iKR9XPq7XnU8',
    appId: '1:213146812952:ios:0868e81fb43f9ec275f96d',
    messagingSenderId: '213146812952',
    projectId: 'project-valinity',
    storageBucket: 'project-valinity.appspot.com',
    iosClientId: '213146812952-lkecg8m2koa4ootflqkvi0boajnot7vp.apps.googleusercontent.com',
    iosBundleId: 'com.example.project',
  );
}