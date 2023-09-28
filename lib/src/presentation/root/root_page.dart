import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller/src/presentation/add_conversation/add_conversation_page.dart';
import 'package:taller/src/presentation/conversations/conversations_page.dart';
import 'package:taller/src/presentation/menu/menu_page.dart';
import 'package:taller/src/utils/utils.dart';

import '../widgets/widgets.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (idx) {
          idx == 1
              ? {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cerrar Sesión'),
                        content: Text('Estas seguro de cerrar sesión?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Sign Out'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppTheme.theme.primaryColor)),
                            onPressed: () {
                              onSignOut();
                            },
                          ),
                        ],
                      );
                    },
                  )
                }
              : onChangedIndex(idx);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Majes.chat_line),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            label: 'SignOut',
            icon: Icon(Majes.logout_line),
          ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void addConversation() => showCupertinoModalPopup(
        context: context,
        builder: (ctx) => const UsersPage(),
      );

  void onChangedIndex(int value) {
    if (currentIndex == value) return;
    setState(() {
      currentIndex = value;
    });
  }

  void onSignOut() async {
    try {
      context.showPreloader();
      await supa.auth.signOut();
      if (!mounted) return;
      await context.hidePreloader();
    } on Exception catch (e) {
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
