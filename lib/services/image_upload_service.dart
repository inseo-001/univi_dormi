import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ImageUploadService {
  ImageUploadService({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String?> pickAndUploadChatImage({
    required String chatId,
    required String senderId,
  }) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'],
      allowMultiple: false,
      withData: true, // web/app 모두에서 바이트 확보
    );

    if (result == null || result.files.isEmpty) {
      return null; // 취소
    }

    final PlatformFile file = result.files.first;
    final Uint8List? bytes = file.bytes;
    if (bytes == null) return null;

    final String fileName = file.name;
    final String path =
        'chat_images/$chatId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    final SettableMetadata metadata = SettableMetadata(
      contentType: _inferContentType(file.extension),
    );

    final Reference ref = _storage.ref().child(path);
    final UploadTask uploadTask = ref.putData(bytes, metadata);
    await uploadTask.whenComplete(() {});
    final String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  String _inferContentType(String? ext) {
    final String e = (ext ?? '').toLowerCase();
    switch (e) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }
}
