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
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }
}
