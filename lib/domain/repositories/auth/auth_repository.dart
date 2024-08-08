import '../../entities/auth/user.dart';

abstract class AuthRepository {

  
  Future<User?> signInWithGoogle();

  Future<void> signOut();

  User? getCurrentUser();

}