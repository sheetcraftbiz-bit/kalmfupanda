import 'dart:html' as html;
import '../models/quote_model.dart';

/// Web-based share card generator using HTML Canvas
class CardGenerator {
  /// Generate and download a share card
  static void generateAndDownload(Quote quote, String cardType) {
    // Create canvas
    final canvas = html.CanvasElement(width: 1080, height: 1350);
    final ctx = canvas.getContext('2d') as html.CanvasRenderingContext2D?;

    if (ctx == null) {
      print('Failed to get canvas context');
      return;
    }

    final width = canvas.width ?? 1080;
    final height = canvas.height ?? 1350;

    // Draw based on card type
    switch (cardType) {
      case 'colorful':
        _drawColorfulCard(ctx, width, height);
        break;
      case 'appleNotes':
        _drawAppleNotesCard(ctx, width, height);
        break;
      case 'twitter':
        _drawTwitterCard(ctx, width, height);
        break;
    }

    // Draw quote text (common for all cards)
    _drawQuoteText(ctx, width, height, quote, cardType);

    // Convert to image and download
    final dataUrl = canvas.toDataUrl('image/png');
    _downloadImage(dataUrl);
  }

  static void _drawColorfulCard(
    html.CanvasRenderingContext2D ctx,
    int width,
    int height,
  ) {
    final gradient = ctx.createLinearGradient(0, 0, width.toDouble(), height.toDouble());
    gradient.addColorStop(0, '#833ab4');
    gradient.addColorStop(0.5, '#fd1d1d');
    gradient.addColorStop(1, '#fcb045');

    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width.toDouble(), height.toDouble());

    ctx.fillStyle = 'rgba(0, 0, 0, 0.2)';
    ctx.fillRect(0, 0, width.toDouble(), height.toDouble());
  }

  static void _drawAppleNotesCard(
    html.CanvasRenderingContext2D ctx,
    int width,
    int height,
  ) {
    ctx.fillStyle = '#F5F5F7';
    ctx.fillRect(0, 0, width.toDouble(), height.toDouble());

    ctx.fillStyle = '#C8A96E';
    ctx.fillRect(80, 80, 80, 6);
  }

  static void _drawTwitterCard(
    html.CanvasRenderingContext2D ctx,
    int width,
    int height,
  ) {
    ctx.fillStyle = '#000000';
    ctx.fillRect(0, 0, width.toDouble(), height.toDouble());

    // Avatar
    ctx.beginPath();
    ctx.arc(width / 2.0, 200, 80, 0, 6.28318);
    ctx.fillStyle = '#C8A96E';
    ctx.fill();

    ctx.font = 'bold 64px -apple-system, sans-serif';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('P', width / 2.0, 200);

    // Username
    ctx.font = 'normal 28px -apple-system, sans-serif';
    ctx.fillStyle = '#71767B';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'alphabetic';
    ctx.fillText('@slowpanda', width / 2.0, 320);
  }

  static void _drawQuoteText(
    html.CanvasRenderingContext2D ctx,
    int width,
    int height,
    Quote quote,
    String cardType,
  ) {
    final isDark = cardType == 'twitter' || cardType == 'colorful';
    final isColorful = cardType == 'colorful';

    // Text settings based on card type (with larger readable sizes)
    final textColor = isDark ? (isColorful ? '#FFFFFF' : '#E7E9EA') : '#1D1D1F';
    final subTextColor = isDark ? (isColorful ? 'rgba(255,255,255,0.9)' : '#71767B') : '#86868B';
    final accentColor = isColorful ? 'rgba(255,255,255,0.6)' : '#C8A96E';
    final startY = cardType == 'twitter' ? 500 : 450;

    // Draw quote text with larger, readable font sizes
    final words = quote.text.split(' ');
    final lines = <String>[];
    String currentLine = '';
    final maxWidth = width - 160;

    // Increased font sizes for better readability (matching Flutter widget sizes)
    double fontSize;
    double lineHeight;
    if (cardType == 'twitter') {
      fontSize = 72.0;  // Was 50, now matches 24px × 3
      lineHeight = 90.0;  // Was 68
    } else {
      fontSize = 78.0;  // Was 52, now matches 26px × 3
      lineHeight = 100.0;  // Was 70
    }

    ctx.font = 'italic $fontSize Georgia, serif';
    ctx.fillStyle = textColor;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'top';

    for (final word in words) {
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';
      final metrics = ctx.measureText(testLine);

      if (metrics.width! > maxWidth && currentLine.isNotEmpty) {
        lines.add(currentLine);
        currentLine = word;
      } else {
        currentLine = testLine;
      }
    }
    lines.add(currentLine);

    // Draw each line
    final totalHeight = lines.length * lineHeight;
    var currentY = startY - totalHeight / 2 + lineHeight / 2;

    for (final line in lines) {
      ctx.fillText(line, width / 2.0, currentY);
      currentY += lineHeight;
    }

    // Draw author with increased size
    final authorFontSize = cardType == 'twitter' ? 48.0 : 54.0;  // Was 32/28
    ctx.font = 'normal $authorFontSize -apple-system, sans-serif';
    ctx.fillStyle = subTextColor;
    ctx.textAlign = 'center';

    final authorText = cardType == 'twitter'
        ? '${quote.author} · slowpanda'
        : '— ${quote.author}';

    ctx.fillText(authorText, width / 2.0, (height - 150).toDouble());

    // Draw watermark with increased size
    final watermarkFontSize = cardType == 'twitter' ? 36.0 : 39.0;  // Was 24/22
    ctx.font = 'normal $watermarkFontSize -apple-system, sans-serif';
    ctx.fillStyle = accentColor;
    ctx.fillText('slowpanda', width / 2.0, (height - 80).toDouble());
  }

  static void _downloadImage(String dataUrl) {
    try {
      final anchor = html.AnchorElement()
        ..href = dataUrl
        ..download = 'slowpanda_${DateTime.now().millisecondsSinceEpoch}.png'
        ..style.display = 'none';

      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
    } catch (e) {
      print('Error downloading image: $e');
    }
  }
}
