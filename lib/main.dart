import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cancioneroruah/config/firebase/firebase_options.dart';
import 'package:cancioneroruah/config/router/app_router.dart';
import 'package:cancioneroruah/config/config.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MainApp()
    )
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appRouterProvider =  ref.watch(appRouter);
    final AppTheme appTheme = ref.watch( themeNotifierProvider );

    return MaterialApp.router(
      routerDelegate: appRouterProvider.routerDelegate,
      routeInformationParser: appRouterProvider.routeInformationParser,
      routeInformationProvider: appRouterProvider.routeInformationProvider,
      theme: appTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      );
  }
}
