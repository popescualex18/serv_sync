import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';

void saveImage(Uint8List pngBytes, String fileName, BuildContext context) {
  final blob = html.Blob([pngBytes], 'image/png');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Meniul a fost descarcat!")),
  );
}
