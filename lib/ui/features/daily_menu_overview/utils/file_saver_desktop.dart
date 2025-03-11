import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<void> saveImage(Uint8List pngBytes, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final File imgFile = File(filePath);
  await imgFile.writeAsBytes(pngBytes);
  print("Saved to $filePath");
}
