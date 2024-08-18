
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
import 'package:cancioneroruah/presentation/providers/auth/auth_change_notifier.dart';
import 'package:cancioneroruah/presentation/screens/screens.dart';


class RepertorieListScreen extends ConsumerStatefulWidget {
  static const String name = 'repertorie-list-screen';
  const RepertorieListScreen({super.key});

  @override
  ConsumerState<RepertorieListScreen> createState() => _RepertorieListScreen();
}


class _RepertorieListScreen extends ConsumerState<RepertorieListScreen> {

  @override
  void initState() {
    super.initState();
    final user = ref.read(authChangeNotifierProvider).user;
    ref.read(repertoireNotifierProvider.notifier).loadRepertoires(user!.id);
  }
  

  @override
  Widget build(BuildContext context) {

    final repertoires = ref.watch(repertoireNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis esquemas'),
      ),


      body: repertoires.isEmpty
          ? const _PreAddRepertoire()
          : ListView.builder(
              itemCount: repertoires.length,
              itemBuilder: (context, index) {
                final repertoire = repertoires[index];
                return FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: Card(
                    child: ListTile(
                      title: Text(repertoire.title, style: GoogleFonts.robotoMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) async {
                          if(value == 'edit'){
                             final updatedName = await _showEditRepertoireDialog(context, repertoire);
                             if (updatedName != null && updatedName.isNotEmpty) {
                                ref.read(repertoireNotifierProvider.notifier).updateRepertoireTitle(repertoire.id, updatedName);
                              }
                          }else{
                            ref.read(repertoireNotifierProvider.notifier).deleteRepertoire(repertoire.id);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.edit_note),
                                ),
                                Text('Editar Esquema'),
                              ],
                            ),
                          ),
                    
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.delete),
                                ),
                                Text('Eliminar Esquema'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        context.go('/home/repertories/repertoire-detail', extra: repertoire);
                      },
                    ),
                  ),
                );
              },
            ),


      floatingActionButton: FloatingActionButton.extended(
        icon:  const Icon(Icons.add),
        label: const Text('Agregar esquema'),
        onPressed: () async{
          final name =  await _showAddRepertoireDialog(context);
          if (name != null && name.isNotEmpty) {

            final newRepertoire = Repertoire(
              id: '', 
              title: name, 
              userId: "", 
              songIds: []
            );

            if(context.mounted){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddSongsToRepertoireScreen(
                    repertoire: newRepertoire,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }



  Future<String?> _showAddRepertoireDialog(BuildContext context) async {

    final GlobalKey<FormState> form = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (context) {
        String name = '';
        return AlertDialog(
          title: const Text(''),
          content: Form(
            key: form,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Titulo del esquema",
                hintStyle: TextStyle(fontSize: 13)
              ),
              onSaved: (String ? value) {
                name = value ?? '';
              },
              validator: (value) {
                return (value != null && value.isEmpty) ? 'Agrega el nombre del Esquema' : null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Registrar'),
              onPressed: () {
                if(form.currentState?.validate() ?? false){
                  form.currentState?.save();
                  //context.goNamed('add-repertoire', extra: name);
                  Navigator.of(context).pop(name);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

Future<String?> _showEditRepertoireDialog(BuildContext context, Repertoire repertoire) async {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController(text: repertoire.title);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar nombre del esquema'),
        content: Form(
          key: form,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Nuevo título del esquema",
              hintStyle: TextStyle(fontSize: 13)
            ),
            validator: (value) {
              return (value != null && value.isEmpty) ? 'Agrega el nombre del Esquema' : null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Actualizar'),
            onPressed: () {
              if (form.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
          ),
        ],
      );
    }
  );
}

class _PreAddRepertoire extends StatelessWidget {
  const _PreAddRepertoire();

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: const Duration(milliseconds: 200),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                  'No tienes esquemas agregados. \n Para agregar un "Esquema" pulsa el icono de abajo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
