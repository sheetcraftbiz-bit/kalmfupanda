import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';

class ShareCardTwitter extends StatelessWidget {
  final Quote quote;

  const ShareCardTwitter({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border.all(
          color: const Color(0xFF2f3336),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile row
          Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Name and handle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KalmFu Panda',
                    style: TextStyle(
                      fontSize: 20,  // Increased from 15
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '@kalmfupanda',
                    style: TextStyle(
                      fontSize: 17,  // Increased from 14
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quote text with flexible sizing
          Flexible(
            child: _buildQuoteText(),
          ),

          const SizedBox(height: 12),

          // Author line
          Text(
            '— ${quote.author}',
            style: TextStyle(
              fontSize: 17,  // Increased from 14
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Bottom bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _formatTime(DateTime.now()),
                    style: TextStyle(
                      fontSize: 15,  // Increased from 13
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('·', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                  const SizedBox(width: 4),
                  const Text(
                    'KalmFu Panda',
                    style: TextStyle(
                      fontSize: 15,  // Increased from 13
                      color: Color(0xFF1d9bf0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Credit line
              Text(
                'Find the way to Kalm Like Panda · Available on App Store',
                style: TextStyle(
                  fontSize: 12,  // Increased from 10
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteText() {
    // Calculate font size based on quote length
    // Increased for better readability
    final wordCount = quote.text.split(' ').length;
    final lineCount = (quote.text.length / 40).ceil();

    double fontSize = 24;  // Increased from 18
    if (lineCount >= 3 || wordCount >= 15) {
      fontSize = 20;  // Increased from 16
    } else if (lineCount >= 4 || wordCount >= 20) {
      fontSize = 18;  // Increased from 14
    }

    return Text(
      '"${quote.text}"',
      style: TextStyle(
        fontSize: fontSize,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      maxLines: 8,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
