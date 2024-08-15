
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:cancioneroruah/domain/entities/song/repertoire.dart';
import 'package:cancioneroruah/presentation/notifiers/song/repertoire_notifier.dart';
import 'package:cancioneroruah/presentation/providers/auth/auth_change_notifier.dart';
import 'package:cancioneroruah/presentation/screens/screens.dart';


class RepertorieScreen extends ConsumerStatefulWidget {
  static const String name = 'repertorie-screen';
  const RepertorieScreen({super.key});

  @override
  ConsumerState<RepertorieScreen> createState() => _RepertorieScreen();
}


class _RepertorieScreen extends ConsumerState<RepertorieScreen> {

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
                return ListTile(
                  title: Text(repertoire.title, style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String value){
                      if(value == 'edit'){

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
                );
              },
            ),


      floatingActionButton: FloatingActionButton.extended(
        icon:  const Icon(Icons.add),
        label: const Text('Agregar Esquema'),
        onPressed: () async{
          final name =  await _showAddRepertoireDialog(context);
          if (name != null && name.isNotEmpty) {

            if(context.mounted){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddSongsToRepertoireScreen(
                    repertoireTitle: name,
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

class _PreAddRepertoire extends StatelessWidget {
  const _PreAddRepertoire();

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
