import '../../entities/auth/user.dart';

abstract class AuthDatasource {

  Future<User> login ();

  Future<User> checkAuthStatus ();

}