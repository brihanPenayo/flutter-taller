import 'package:flutt_chat/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutt_chat/src/utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var title = '';
  final supabase = getIt.get<SupabaseClient>();
  void init() async {
    // await for for the widget to mount
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final session = supabase.auth.currentSession;
    if (session == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (v) => false);
      return;
    }

    if (!(session.user.userMetadata?.containsKey('profile_completed') ??
        false)) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/completeProfile',
        (v) => false,
      );
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil('/', (v) => false);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: AppTheme.theme.primaryColor,
        )),
      ),
    );
  }
}
