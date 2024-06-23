// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBDpLeH13FItEJ7GYswwfwZQ3nbp5xWZ8Q',
    appId: '1:733865597439:web:c9dd35f434c624900a2fca',
    messagingSenderId: '733865597439',
    projectId: 'my-first-firebase-app-b72e0',
    authDomain: 'my-first-firebase-app-b72e0.firebaseapp.com',
    storageBucket: 'my-first-firebase-app-b72e0.appspot.com',
    measurementId: 'G-R378FHQBKR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzPcd0vKHHw7j5rYh7alDy5tceLGdZemg',
    appId: '1:733865597439:android:92b94e277d8da7300a2fca',
    messagingSenderId: '733865597439',
    projectId: 'my-first-firebase-app-b72e0',
    storageBucket: 'my-first-firebase-app-b72e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZdZ1_3CIiR_QSuw41gxlAm6zY-uwWXYQ',
    appId: '1:733865597439:ios:d7f68d6b0ac493b00a2fca',
    messagingSenderId: '733865597439',
    projectId: 'my-first-firebase-app-b72e0',
    storageBucket: 'my-first-firebase-app-b72e0.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZdZ1_3CIiR_QSuw41gxlAm6zY-uwWXYQ',
    appId: '1:733865597439:ios:d7f68d6b0ac493b00a2fca',
    messagingSenderId: '733865597439',
    projectId: 'my-first-firebase-app-b72e0',
    storageBucket: 'my-first-firebase-app-b72e0.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDpLeH13FItEJ7GYswwfwZQ3nbp5xWZ8Q',
    appId: '1:733865597439:web:d78bac8b5c341ac00a2fca',
    messagingSenderId: '733865597439',
    projectId: 'my-first-firebase-app-b72e0',
    authDomain: 'my-first-firebase-app-b72e0.firebaseapp.com',
    storageBucket: 'my-first-firebase-app-b72e0.appspot.com',
    measurementId: 'G-8T0D2P608H',
  );
}
