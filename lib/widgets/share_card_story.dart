import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class ShareCardStory extends StatelessWidget {
  final Quote quote;
  final bool isInstagram;

  const ShareCardStory({
    super.key,
    required this.quote,
    this.isInstagram = true,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = isInstagram
        ? AppColors.igStoryGradient
        : AppColors.fbStoryGradient;

    final stops = List.generate(
      gradientColors.length,
      (index) => index / (gradientColors.length - 1),
    );

    return Container(
      width: 360,
      height: 640,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: stops,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Quote mark
                Text(
                  '"',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 40,
                    color: Colors.white.withOpacity(0.3),
                    fontStyle: FontStyle.italic,
                    height: 0.8,
                  ),
                ),

                const SizedBox(height: 8),

                // Quote text - adjust font size based on length
                _buildQuoteText(),

                const SizedBox(height: 12),

                // Divider
                Container(
                  width: 28,
                  height: 2,
                  color: Colors.white.withOpacity(0.6),
                ),

                const SizedBox(height: 12),

                // Author
                Text(
                  '— ${quote.author.toUpperCase()}',
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 16,  // Increased from 11
                    letterSpacing: 2.0,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // Watermark
                Text(
                  'KALMFU PANDA',
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 13,  // Increased from 9
                    letterSpacing: 3.0,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteText() {
    // Calculate font size based on quote length
    // Increased for better readability at 1080x1920 output
    final wordCount = quote.text.split(' ').length;
    final lineCount = (quote.text.length / 35).ceil();

    double fontSize = 26;  // Increased from 18
    if (lineCount >= 3 || wordCount >= 15) {
      fontSize = 22;  // Increased from 16
    } else if (lineCount >= 4 || wordCount >= 20) {
      fontSize = 20;  // Increased from 14
    }

    return Flexible(
      child: Text(
        '"${quote.text}"',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: Colors.white,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
