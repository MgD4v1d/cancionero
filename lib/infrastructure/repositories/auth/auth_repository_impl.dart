import 'package:cancioneroruah/domain/domain.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDatasource dataSource;

  AuthRepositoryImpl(
    AuthDatasource? dataSource
  ) : dataSource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus() {
    return dataSource.checkAuthStatus();
  }

  @override
  Future<User> login() {
    return dataSource.login();
  }

}