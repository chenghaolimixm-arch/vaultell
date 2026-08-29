import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies a picked file into the app's private documents directory.
class DocumentStorageService {
  Future<String> savePickedFile({
    required String sourcePath,
    required String fileName,
  }) async {
    final base = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(base.path, 'policy_documents'));
    await folder.create(recursive: true);
    final targetPath = p.join(folder.path, '${DateTime.now().millisecondsSinceEpoch}_$fileName');
    await File(sourcePath).copy(targetPath);
    return targetPath;
  }

  Future<void> deleteStoredFile(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Missing/corrupt file should not block removing the record.
    }
  }
}
