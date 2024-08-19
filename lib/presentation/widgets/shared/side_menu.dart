import 'package:cancioneroruah/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancioneroruah/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends ConsumerWidget{
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme; 

    final user = ref.watch(authChangeNotifierProvider).user;
    final isDarkmode = ref.watch( themeNotifierProvider ).isDarkmode;

    return Drawer(
      child: NavigationDrawer(
        elevation: 1,
        children: [

          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: colors.primary
            ),
            accountName: Text(user?.name ?? 'Guest', style: TextStyle(
              color: isDarkmode ? Colors.black : Colors.white
            ),),
            accountEmail: Text(user?.email ?? '', style: TextStyle(
              color: isDarkmode ? Colors.black : Colors.white
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                user?.photoUrl ?? 'https://via.placeholder.com/150'
              ),
             ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
            child: Text('Otras opciones'),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Preferencias'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ThemeChangerScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              ref.read(authChangeNotifierProvider.notifier).signOut();
              context.go('/');
            },
          ),

        ],
      ),
    );
  }

}