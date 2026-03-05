import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

/// Web-based share card generator using HTML Canvas
/// This is the most reliable method for Flutter Web/PWA
class WebCardGenerator {
  /// Generate a share card as downloadable image
  static void generateShareCard(Quote quote, ShareCardType type) {
    if (!kIsWeb) return;

    // Create canvas
    final canvas = html.CanvasElement(width: 1080, height: 1350);
    final ctx = canvas.getContext('2d') as html.CanvasRenderingContext2D;

    if (ctx == null) {
      print('Failed to get canvas context');
      return;
    }

    // Draw based on card type
    switch (type) {
      case ShareCardType.colorful:
        _drawColorfulCard(ctx, quote, canvas);
        break;
      case ShareCardType.appleNotes:
        _drawAppleNotesCard(ctx, quote, canvas);
        break;
      case ShareCardType.twitter:
        _drawTwitterCard(ctx, quote, canvas);
        break;
    }

    // Convert to image and download
    final dataUrl = canvas.toDataUrl('image/png');
    _downloadImage(dataUrl, quote);
  }

  // Draw colorful gradient card (Instagram style)
  static void _drawColorfulCard(
    html.CanvasRenderingContext2D ctx,
    Quote quote,
    html.CanvasElement canvas,
  ) {
    final width = canvas.width;
    final height = canvas.height;

    // Gradient background (Instagram story gradient)
    final gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, '#833ab4'); // Purple
    gradient.addColorStop(0.5, '#fd1d1d'); // Red
    gradient.addColorStop(1, '#fcb045'); // Orange

    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);

    // Add subtle overlay
    ctx.fillStyle = 'rgba(0, 0, 0, 0.2)';
    ctx.fillRect(0, 0, width, height);

    // Draw quote text
    _drawWrappedText(
      ctx,
      quote.text,
      x: 80,
      y: 480,
      maxWidth: width - 160,
      lineHeight: 72,
      fontSize: 56,
      fontFamily: 'Georgia, serif',
      color: '#FFFFFF',
      italic: true,
    );

    // Draw author
    ctx.font = 'normal 32px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
    ctx.textAlign = 'center';
    ctx.fillText('— ${quote.author}', width / 2, height - 180);

    // Draw watermark
    ctx.font = 'normal 24px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = 'rgba(255, 255, 255, 0.6)';
    ctx.textAlign = 'center';
    ctx.fillText('slowpanda', width / 2, height - 80);
  }

  // Draw Apple Notes style card
  static void _drawAppleNotesCard(
    html.CanvasRenderingContext2D ctx,
    Quote quote,
    html.CanvasElement canvas,
  ) {
    final width = canvas.width;
    final height = canvas.height;

    // Paper texture background
    ctx.fillStyle = '#F5F5F7';
    ctx.fillRect(0, 0, width, height);

    // Draw accent line at top
    ctx.fillStyle = '#C8A96E'; // Bamboo Gold
    ctx.fillRect(80, 80, 80, 6);

    // Draw quote text
    _drawWrappedText(
      ctx,
      quote.text,
      x: 100,
      y: 450,
      maxWidth: width - 200,
      lineHeight: 70,
      fontSize: 52,
      fontFamily: 'Georgia, serif',
      color: '#1D1D1F',
      italic: true,
    );

    // Draw author
    ctx.font = 'normal 28px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = '#86868B';
    ctx.textAlign = 'center';
    ctx.fillText('— ${quote.author}', width / 2, height - 150);

    // Draw watermark
    ctx.font = 'normal 22px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = '#C8A96E';
    ctx.textAlign = 'center';
    ctx.fillText('slowpanda', width / 2, height - 80);
  }

  // Draw Twitter/X style card
  static void _drawTwitterCard(
    html.CanvasRenderingContext2D ctx,
    Quote quote,
    html.CanvasElement canvas,
  ) {
    final width = canvas.width;
    final height = canvas.height;

    // Dark background
    ctx.fillStyle = '#000000';
    ctx.fillRect(0, 0, width, height);

    // Draw avatar circle
    ctx.beginPath();
    ctx.arc(width / 2, 200, 80, 0, 2 * 3.14159);
    ctx.fillStyle = '#C8A96E';
    ctx.fill();

    // Draw "P" in avatar
    ctx.font = 'bold 64px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = '#000000';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('P', width / 2, 200);

    // Draw username
    ctx.font = 'normal 28px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = '#71767B';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'alphabetic';
    ctx.fillText('@slowpanda', width / 2, 320);

    // Draw quote text
    _drawWrappedText(
      ctx,
      quote.text,
      x: 80,
      y: 500,
      maxWidth: width - 160,
      lineHeight: 68,
      fontSize: 50,
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
      color: '#E7E9EA',
      italic: false,
    );

    // Draw author with separator
    ctx.font = 'normal 32px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    ctx.fillStyle = '#71767B';
    ctx.textAlign = 'center';
    ctx.fillText('${quote.author} · slowpanda', width / 2, height - 120);
  }

  // Helper: Draw wrapped text
  static void _drawWrappedText(
    html.CanvasRenderingContext2D ctx,
    String text, {
    required double x,
    required double y,
    required double maxWidth,
    required double lineHeight,
    required double fontSize,
    required String fontFamily,
    required String color,
    required bool italic,
  }) {
    final words = text.split(' ');
    final lines = <String>[];
    String currentLine = '';

    ctx.font = '${italic ? 'italic' : 'normal'} $fontSize $fontFamily';
    ctx.fillStyle = color;
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
    let startY = y - totalHeight / 2 + lineHeight / 2;

    for (final line in lines) {
      ctx.fillText(line, x + maxWidth / 2, startY);
      startY += lineHeight;
    }
  }

  // Download the generated image
  static void _downloadImage(String dataUrl, Quote quote) {
    try {
      // Create anchor element
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

enum ShareCardType { colorful, appleNotes, twitter }
