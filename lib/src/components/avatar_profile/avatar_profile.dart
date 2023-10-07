import 'package:flutt_chat/src/presentation/widgets/widgets.dart';
import 'package:flutt_chat/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_quickstart/main.dart';

class AvatarProfile extends StatefulWidget {
  const AvatarProfile({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function() onUpload;

  @override
  _AvatarProfileState createState() => _AvatarProfileState();
}

class _AvatarProfileState extends State<AvatarProfile> {
  bool _isLoading = false;
  final supabase = getIt.get<SupabaseClient>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          GestureDetector(
              onTap: _isLoading ? null : widget.onUpload,
              child: Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                color: AppTheme.theme.primaryColor.withOpacity(0.3),
                child: const Center(
                  child: Icon(size: 50, Icons.add_a_photo),
                ),
              ))
        else
          GestureDetector(
              onTap: _isLoading ? null : widget.onUpload,
              child: Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(bottom: 16),
                color: AppTheme.theme.primaryColor.withOpacity(0.3),
                child: Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                ),
              )),
        if (widget.imageUrl!.isNotEmpty) const Text("Toque para cambiar"),
      ],
    );
  }
}

// Stacktrace
