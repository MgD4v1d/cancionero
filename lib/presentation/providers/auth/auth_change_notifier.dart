import 'package:cancioneroruah/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cancioneroruah/infrastructure/infrastructure.dart';
import 'package:cancioneroruah/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthChangeNotifier extends ChangeNotifier{
  final AuthRepositoryImpl authRepository;
  User? _user;

  AuthChangeNotifier(this.authRepository) {
    _init();
  }

  User? get user => _user;


  Future<void> _init() async {
    _user = authRepository.getCurrentUser();
    notifyListeners();
  }


  Future<void> signInWithGoogle() async {
    _user = await authRepository.signInWithGoogle();
    notifyListeners();
  }


  Future<void> signOut() async {
    await authRepository.signOut();
    _user = null;
    notifyListeners();
  }

}

final authChangeNotifierProvider = ChangeNotifierProvider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthChangeNotifier(authRepository);
});