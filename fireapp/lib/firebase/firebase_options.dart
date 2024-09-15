import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
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

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
    appId: dotenv.env['ANDROID_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['ANDROID_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['ANDROID_PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['ANDROID_STORAGE_BUCKET'] ?? '',
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['IOS_API_KEY'] ?? '',
    appId: dotenv.env['IOS_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['IOS_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['IOS_PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['IOS_STORAGE_BUCKET'] ?? '',
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? '',
  );
}