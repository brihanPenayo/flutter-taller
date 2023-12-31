// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutt_chat/src/presentation/complete_profile/complete_profile.dart';
import 'package:flutt_chat/src/presentation/conversation/conversation_page.dart';
import 'package:flutt_chat/src/presentation/login/login_page.dart';
import 'package:flutt_chat/src/presentation/register/register_page.dart';
import 'package:flutt_chat/src/presentation/root/root_page.dart';
import 'package:flutt_chat/src/presentation/splash/splah_page.dart';
import 'package:flutt_chat/src/presentation/widgets/widgets.dart';
import 'package:flutt_chat/src/utils/utils.dart';

void main() async {
  await dotenv.load();
  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations(
    const [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  getIt.registerSingleton(supabase.client);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluttChat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/splash',
      routes: {
        '/': (ctx) => const RootPage(),
        '/splash': (ctx) => const SplashPage(),
        '/login': (ctx) => const LoginPage(),
        '/signup': (context) => const RegisterPage(),
        '/conversation': (context) => const ConversationPage(),
        '/completeProfile': (context) => const CompleteProfile(),
      },
      // home: const HomePage(),
    );
  }
}
