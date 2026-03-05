import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

/// Web-only image capture using RepaintBoundary
class WebCapture {
  /// Captures a widget as an image using RepaintBoundary
  static Future<Uint8List?> capture(GlobalKey key) async {
    try {
      final context = key.currentContext;
      if (context == null) {
        return null;
      }

      final renderObject = context.findRenderObject();
      if (renderObject == null || renderObject is! RenderRepaintBoundary) {
        return null;
      }

      final boundary = renderObject as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      return byteData.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}
