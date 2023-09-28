import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutt_chat/src/presentation/add_conversation/add_conversation_page.dart';
import 'package:flutt_chat/src/presentation/conversations/conversations_page.dart';
import 'package:flutt_chat/src/presentation/menu/menu_page.dart';
import 'package:flutt_chat/src/utils/utils.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final supa = getIt.get<SupabaseClient>();

  @override
  void initState() {
    // supa.auth.signOut();
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          ConversationsPage(),
          MenuPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        // backgroundColor: Colors.deepPurple,
        onPressed: addConversation,
        isExtended: true,

        child: const Icon(Icons.add, size: 32),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void addConversation() => showCupertinoModalPopup(
        context: context,
        builder: (ctx) => const UsersPage(),
      );
}
