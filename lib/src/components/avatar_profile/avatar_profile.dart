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
  final void Function(String) onUpload;

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
              onTap: _isLoading ? null : _upload,
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
              onTap: _isLoading ? null : _upload,
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

  Future<void> _upload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    final fileExt = imageFile.path.split('.').last.toLowerCase();
    final bytes = await imageFile.readAsBytes();
    final userId = supabase.auth.currentUser!.id;
    final filePath = '/$userId/profile';
    await supabase.storage.from('avatars').uploadBinary(
          filePath,
          bytes,
          fileOptions:
              FileOptions(upsert: true, contentType: 'images/$fileExt'),
        );

    String imageUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    widget.onUpload(imageUrl);

    setState(() => _isLoading = false);
  }
}
