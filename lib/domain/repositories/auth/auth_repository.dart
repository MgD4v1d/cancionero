import '../../entities/auth/user.dart';

abstract class AuthRepository {

  Future<User?> login ();

  Future<User> checkAuthStatus ();

}