import '../../entities/auth/user.dart';

abstract class AuthDatasource {

  Future<User> login ();

  Future<void> signOut();

  Future<User> checkAuthStatus ();

  User? getCurrentUser();

}