import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutt_chat/src/utils/utils.dart';

import '../../../models/models.dart';
import '../../widgets/widgets.dart';

class ConversationWidget extends StatefulWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  const ConversationWidget({
    Key? key,
    required this.conversation,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  final supabase = getIt.get<SupabaseClient>();
  Future<dynamic> getTitle() async {
    if (widget.conversation.title.isNotEmpty) {
      return [widget.conversation.title, ""];
    }
    final myId = supabase.auth.currentUser!.id;
    final id = widget.conversation.participants.where((e) => e != myId).first;
    if (Profile.cache.containsKey(id)) {
      return Profile.cache[id]!.data;
    }
    return await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .then((value) => Profile.cache[id] = Profile.fromMap(value))
        .then((value) => value.data);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getTitle(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return emptyWidget;
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Hubo un error'));
        }
        return ListTile(
          contentPadding: zero,
          leading: CircleAvatar(
            backgroundColor: AppTheme.theme.primaryColor.withOpacity(0.7),
            foregroundColor: Colors.white,
            foregroundImage: NetworkImage(snapshot.data![1]),
            child: widget.conversation.title.isEmpty
                ? const Icon(Icons.person, size: 28)
                : const Icon(Icons.groups, size: 28),
          ),
          onTap: widget.onTap,
          subtitle: Row(
            children: [
              Expanded(
                flex: 8,
                child: Text(
                  widget.conversation.preview,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.conversation.modifiedAt!.hourFormat,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          title: Text(snapshot.data![0]),
        );
      },
    );
  }
}
