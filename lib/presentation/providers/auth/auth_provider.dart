import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cancioneroruah/domain/entities/auth/user.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';


class AuthNotifier extends StateNotifier<User?>{

  final AuthRepositoryImpl authRepository;

  AuthNotifier(this.authRepository) : super(authRepository.getCurrentUser());


  Future<void> signIn() async {
    final user = await authRepository.signInWithGoogle();
    state = user;
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    state = null;
  }

}

final firebaseAuthProvider = Provider((ref) => firebase_auth.FirebaseAuth.instance);
final googleSignInProvider = Provider((ref) => GoogleSignIn());

final firebaseAuthDatasourceProvider = Provider((ref) => FirebaseAuthDatasource(ref.watch(firebaseAuthProvider)));
final googleSignInDatasourceProvider = Provider((ref) => GoogleSigninDatasource(ref.watch(googleSignInProvider)));

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(
  firebaseAuthDatasource: ref.watch(firebaseAuthDatasourceProvider),
  googleSignInDatasource: ref.watch(googleSignInDatasourceProvider),
));


final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});