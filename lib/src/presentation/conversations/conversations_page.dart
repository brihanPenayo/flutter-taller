import 'package:flutt_chat/src/presentation/profile_page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutt_chat/src/presentation/add_conversation/add_conversation_page.dart';

import '../../models/models.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';
import 'widgets/conversation_widget.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final supabase = getIt.get<SupabaseClient>();
  late String id;
  late Stream<List<Conversation>> _stream;

  @override
  void initState() {
    if (!mounted) return;
    id = supabase.auth.currentUser?.id ?? '';
    _stream = supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .order('modified_at')
        .map((event) => event
            .map((e) => Conversation.fromMap(e))
            .where((a) => a.participants.contains(id))
            .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content:
                      const Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.theme.primaryColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppTheme.theme.primaryColor),
                      onPressed: () {
                        onSignOut();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.logout),
        ),
        centerTitle: true,
        title: const Text('Chats'),
        actions: [
          IconButton(icon: const Icon(Majes.user_line), onPressed: showProfile),
        ],
        backgroundColor: AppTheme.theme.primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder<List<Conversation>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator;
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No hay conversaciones aún'));
            }
            final list = snapshot.data!.toList();
            return ListView.separated(
              itemBuilder: (ctx, idx) {
                final item = list[idx];
                return ConversationWidget(
                  conversation: item,
                  onTap: () => onTap(item),
                );
              },
              separatorBuilder: (ctx, idx) => const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 0.5,
              ),
              itemCount: list.length,
            );
          },
        ),
      ),
    );
  }

  void showProfile() => showCupertinoDialog(
        context: context,
        builder: (ctx) => const ProfileManager(),
      );

  void onSignOut() async {
    try {
      context.showPreloader();
      await supabase.auth.signOut();
      if (!mounted) return;
      await context.hidePreloader();
    } on Exception catch (e) {
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void onTap(Conversation item) async {
    // Obtén la instancia de SupabaseClient desde el contexto
    Navigator.of(context).pushNamed('/conversation', arguments: item);

    // Realiza la actualización de la columna 'unread' a 0 en la tabla 'conversations'
    // final response = await supabase
    //     .from('conversations')
    //     .update({'unread': 0}).eq('id', item.id);
    // // .execute();

    // if (response.error != null) {
    //   // Maneja el error en caso de que ocurra
    //   log.d('Error: ${response.error.message}');
    // } else {
    //   // La actualización fue exitosa
    //   log.d('Actualización exitosa');
    // }

    // Navega a la pantalla '/conversation' con los argumentos 'item'
  }
}
