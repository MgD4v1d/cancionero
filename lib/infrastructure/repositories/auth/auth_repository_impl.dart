import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository{

  final FirebaseAuthDatasource firebaseAuthDatasource;
  final GoogleSigninDatasource googleSignInDatasource;


  AuthRepositoryImpl({
    required this.firebaseAuthDatasource,
    required this.googleSignInDatasource,
  });
  
  @override
  User? getCurrentUser() {
    
    final firebase_auth.User? user = firebaseAuthDatasource.getCurrentUser();
    if (user == null) return null;

    return User(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }
  
  @override
  Future<User?> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await googleSignInDatasource.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleSignInDatasource.getAuthentication(googleUser);
    final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebase_auth.User? user = await firebaseAuthDatasource.signInWithCredential(credential);
    if (user == null) return null;

    //TODO: EXTRAC TO MAPPER
    return User(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }
  
  @override
  Future<void> signOut() async {
    await firebaseAuthDatasource.signOut();
    await googleSignInDatasource.signOut();
  }

}