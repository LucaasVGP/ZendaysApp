import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<FirebaseApp> initialize() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: FirebaseOptions(
                 apiKey: 'AIzaSyDMADu7UPNx6RWCAqASHiqGAN2TnBd1zXE',
                 appId: '1:612355617030:android:18753c37263c456a3a6e87',
                 messagingSenderId: '612355617030-eh08fpdkkpcbeo71tmlha1mh1d0vs4d2.apps.googleusercontent.com',
                 projectId: 'zendays-2ab10',
      ),
    );
    return firebaseApp;
  }

  static Future<FirebaseFirestore> getFirestoreInstance() async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance;
  }
}
