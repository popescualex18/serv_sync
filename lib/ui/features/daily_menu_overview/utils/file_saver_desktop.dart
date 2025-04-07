import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveImage(Uint8List pngBytes, String fileName, BuildContext context) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final File imgFile = File(filePath);

  await imgFile.writeAsBytes(pngBytes);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Meniul a fost descarcat $filePath!")),
  );
}
