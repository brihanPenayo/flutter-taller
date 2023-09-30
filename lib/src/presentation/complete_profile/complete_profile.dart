import 'package:flutt_chat/src/components/avatar_profile/avatar_profile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/utils.dart';
import '../widgets/widgets.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String? _avatarUrl;
  bool _isLoading = true;
  final key = GlobalKey<FormState>();
  bool obscure = true;
  final supabase = getIt.get<SupabaseClient>();

  Future<void> _getProfile() async {
    setState(() {
      _isLoading = true;
    });
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('profiles')
        .select<Map<String, dynamic>>()
        .eq('id', userId)
        .single();
    firstNameController.text = (data['first_name'] ?? '') as String;
    lastNameController.text = (data['last_name'] ?? '') as String;
    _avatarUrl = (data['avatar_url'] ?? '') as String;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onUpload(String imageUrl) async {
    setState(() {
      _avatarUrl = imageUrl;
    });
    final userId = supabase.auth.currentUser!.id;
    await supabase
        .from('profiles')
        .update({'avatar_url': imageUrl}).eq('id', userId);

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Editar perfil')),
        bottomSheet: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: CustomButton(
              onTap: onComplete,
              label: "Guardar cambios",
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        AvatarProfile(
                            imageUrl: _avatarUrl, onUpload: _onUpload),
                        gap16,
                        CustomTextField(
                          controller: firstNameController,
                          label: "Nombre",
                          required: true,
                          // autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.emailAddress,
                          hint: 'Ingrese su nombre',
                        ),
                        CustomTextField(
                          controller: lastNameController,
                          label: "Apellido",
                          required: true,
                          textCapitalization: TextCapitalization.words,
                          hint: 'Ingrese su apellido',
                        ),
                        // gap32,
                      ],
                    ),
                  ),
                ),
              ));
  }

  void onComplete() async {
    if (!key.currentState!.validate()) return;
    try {
      context.showPreloader();
      final data = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
      };
      await supabase.from('profiles').update(data).eq(
            'id',
            supabase.auth.currentUser?.id,
          );
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'profile_completed': true},
        ),
      );
      if (!mounted) return;
      await context.hidePreloader();
    } on Exception catch (e) {
      await context.hidePreloader();
      if (!mounted) return;
      context.showErrorSnackBar(message: e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).popAndPushNamed('/');
  }
}
