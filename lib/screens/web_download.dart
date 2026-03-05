import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

/// Web-only download functionality
class WebDownload {
  static void downloadImage(Uint8List imageBytes, String filename) {
    final base64 = base64Encode(imageBytes);
    final dataUrl = 'data:image/png;base64,$base64';

    final anchor = html.AnchorElement()
      ..href = dataUrl
      ..download = filename
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
