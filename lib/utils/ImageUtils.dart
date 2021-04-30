import 'dart:convert';
import 'dart:io' as Io;

import 'dart:typed_data';

class ImageUtils {

  static String imageToBase64(Io.File file) {
    final bytes = file.readAsBytesSync();

    return base64Encode(bytes);
  }

  static Uint8List base64ToImage(String strBase64) {
    return base64Decode(strBase64);
  }
}