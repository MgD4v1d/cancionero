import 'package:cancioneroruah/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends ConsumerWidget {

  static const String name = 'login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(authChangeNotifierProvider).user;

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_ruah.png',
              fit: BoxFit.contain,
              width: 200,
            ),
            

            ElevatedButton.icon(
              onPressed: () async{
                ref.read(authChangeNotifierProvider.notifier).signInWithGoogle();

                if(user != null){
                  context.go('/home');
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sing in Filed')
                    ),
                  );
                }
              },
              icon: Image.asset(
                'assets/icons/buscar.png',
                fit: BoxFit.contain,
                width: 25,
              ),
              label: const Text('Iniciar sesión con Google'),
            ),


          ],
        ),
      ),
    );
  }
}
