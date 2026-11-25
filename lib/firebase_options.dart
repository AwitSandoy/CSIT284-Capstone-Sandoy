import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBSapQV2W5G3V3dFA_4tNxuPpVvfZNrNS8',
    appId: '1:18914423993:web:5ded182f10a6e4ccfa9768',
    messagingSenderId: '18914423993',
    projectId: 'mandela-capstone',
    authDomain: 'mandela-capstone.firebaseapp.com',
    storageBucket: 'mandela-capstone.firebasestorage.app',
  );
}