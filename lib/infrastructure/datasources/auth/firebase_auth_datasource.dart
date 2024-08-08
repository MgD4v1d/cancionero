import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


class FirebaseAuthDatasource{

  final firebase_auth.FirebaseAuth firebaseAuth;

  FirebaseAuthDatasource(this.firebaseAuth);


  Future<firebase_auth.User?> signInWithCredential(firebase_auth.AuthCredential credential) async {
    final userCredential = await firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  firebase_auth.User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

}