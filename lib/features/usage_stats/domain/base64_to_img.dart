import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Image? decodeBase64Icon(String? base64Str) {
  if (base64Str == null || base64Str.isEmpty) return null;
  try {
    Uint8List bytes = base64Decode(base64Str);
    return Image.memory(bytes, width: 32, height: 32);
  } catch (_) {
    return null;
  }
}
