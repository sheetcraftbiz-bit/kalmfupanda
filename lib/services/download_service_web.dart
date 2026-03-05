import 'dart:html' as html;
import 'dart:convert';

/// Download service for web platform
class DownloadService {
  /// Download an image from base64 data URL
  static void downloadImageFromBase64(String base64DataUrl, String filename) {
    if (!base64DataUrl.startsWith('data:')) return;

    // Extract base64 data
    final base64 = base64DataUrl.split(',').last;
    final bytes = const Base64Decoder().convert(base64);

    // Create blob
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrl(blob);

    // Create download link
    final anchor = html.AnchorElement()
      ..href = url
      ..download = filename
      ..style.display = 'none';
    
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    // Cleanup
    html.Url.revokeObjectUrl(url);
  }
}
