import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../models/quote_model.dart';
import '../widgets/share_card_story.dart';
import '../widgets/share_card_apple_notes.dart';
import '../widgets/share_card_twitter.dart';
import '../theme/app_theme.dart';
import 'web_download.dart' if (dart.library.io) 'web_download_stub.dart';
import '../services/card_generator_service.dart';

enum ShareCardType { colorful, appleNotes, twitter }

class ShareScreen extends StatefulWidget {
  final Quote quote;

  const ShareScreen({
    super.key,
    required this.quote,
  });

  static Future<void> show(BuildContext context, Quote quote) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ShareScreen(quote: quote),
    );
  }

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen>
    with TickerProviderStateMixin {
  ShareCardType _selectedCard = ShareCardType.colorful;
  late PageController _pageController;
  bool _isSaving = false;

  // For mobile: Screenshot controllers
  final ScreenshotController _controller0 = ScreenshotController();
  final ScreenshotController _controller1 = ScreenshotController();
  final ScreenshotController _controller2 = ScreenshotController();

  // For web: GlobalKeys for RepaintBoundary
  final GlobalKey _captureKey0 = GlobalKey(debugLabel: 'capture_0');
  final GlobalKey _captureKey1 = GlobalKey(debugLabel: 'capture_1');
  final GlobalKey _captureKey2 = GlobalKey(debugLabel: 'capture_2');

  final List<ShareCardType> _cardTypes = ShareCardType.values;

  int get _currentIndex => _cardTypes.indexOf(_selectedCard);

  // Get the controller for the currently selected card (mobile)
  ScreenshotController get _currentController {
    switch (_currentIndex) {
      case 0:
        return _controller0;
      case 1:
        return _controller1;
      case 2:
        return _controller2;
      default:
        return _controller0;
    }
  }

  // Get the GlobalKey for the currently selected card (web)
  GlobalKey get _currentKey {
    switch (_currentIndex) {
      case 0:
        return _captureKey0;
      case 1:
        return _captureKey1;
      case 2:
        return _captureKey2;
      default:
        return _captureKey0;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHARE CARD',
                      style: AppTextStyles.uiLabelAccent.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Swipe to change style',
                      style: AppTextStyles.uiLabel.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card preview - PageView for swiping
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedCard = _cardTypes[index];
                });
              },
              itemCount: _cardTypes.length,
              itemBuilder: (context, index) {
                // Get the correct controller/key for this card
                final controller = index == 0
                    ? _controller0
                    : index == 1
                        ? _controller1
                        : _controller2;
                final key = index == 0
                    ? _captureKey0
                    : index == 1
                        ? _captureKey1
                        : _captureKey2;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  // Web: Use RepaintBoundary, Mobile: Use Screenshot
                  child: kIsWeb
                      ? RepaintBoundary(
                          key: key,
                          child: _buildCard(_cardTypes[index]),
                        )
                      : Screenshot(
                          controller: controller,
                          child: _buildCard(_cardTypes[index]),
                        ),
                );
              },
            ),
          ),

          // Dot indicators
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _cardTypes.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.accentGold
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

          // Loading indicator
          if (_isSaving)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.accentGold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Saving...',
                    style: AppTextStyles.uiLabel.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

          // Action buttons - Direct Save and Share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: kIsWeb
                ? _buildWebActionButton()
                : _buildMobileActionButtons(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCard(ShareCardType type) {
    switch (type) {
      case ShareCardType.colorful:
        return ShareCardStory(quote: widget.quote, isInstagram: true);
      case ShareCardType.appleNotes:
        return ShareCardAppleNotes(quote: widget.quote);
      case ShareCardType.twitter:
        return ShareCardTwitter(quote: widget.quote);
    }
  }

  // Web: Single download button
  Widget _buildWebActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSaving ? null : () => _downloadCard(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGold,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.download_rounded,
                    size: 20,
                    color: AppColors.background,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DOWNLOAD CARD',
                    style: AppTextStyles.uiLabelAccent.copyWith(
                      color: AppColors.background,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Mobile: Save to Photos + Share buttons
  Widget _buildMobileActionButtons() {
    return Row(
      children: [
        // Direct Save button
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : () => _saveDirectlyToPhotos(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGold,
                foregroundColor: AppColors.background,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo_library_rounded,
                          size: 20,
                          color: AppColors.background,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SAVE TO PHOTOS',
                          style: AppTextStyles.uiLabelAccent.copyWith(
                            color: AppColors.background,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Share button
        SizedBox(
          width: 80,
          height: 52,
          child: ElevatedButton(
            onPressed: _isSaving ? null : () => _downloadCard(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.accentGold,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: const Icon(
              Icons.ios_share,
              size: 22,
              color: AppColors.accentGold,
            ),
          ),
        ),
      ],
    );
  }

  // Download card
  Future<void> _downloadCard() async {
    setState(() => _isSaving = true);

    try {
      if (kIsWeb) {
        // Web: Use Canvas-based generator (works reliably)
        await Future.delayed(const Duration(milliseconds: 100));
        CardGenerator.generateAndDownload(
          widget.quote,
          _selectedCard.name,
        );
        await Future.delayed(const Duration(milliseconds: 500));
        _showSuccessMinimal();
      } else {
        // Mobile: Use Screenshot package
        await Future.delayed(const Duration(milliseconds: 200));
        final capturedImage = await _captureMobile();

        if (capturedImage == null) {
          _showError('Failed to capture image');
          return;
        }

        await _saveAndShareMobile(capturedImage);
      }
    } catch (e) {
      debugPrint('Error in downloadCard: $e');
      _showError('Failed to save: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Save directly to Photos (mobile only)
  Future<void> _saveDirectlyToPhotos() async {
    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      if (kIsWeb) {
        _showError('Save to Photos not available on web');
        return;
      }

      final capturedImage = await _captureMobile();
      if (capturedImage == null) {
        _showError('Failed to capture image');
        return;
      }

      debugPrint('Saving to gallery, image size: ${capturedImage.length} bytes');

      // Save directly to gallery
      final result = await ImageGallerySaver.saveImage(
        capturedImage,
        quality: 100,
        name: 'kalmfupanda_${DateTime.now().millisecondsSinceEpoch}',
      );

      debugPrint('Save result: $result');

      if (result != null) {
        // Check both possible success indicators
        final bool isSuccess = result['isSuccess'] == true ||
                              result['saved'] == true ||
                              result is String; // On some platforms it returns the file path

        if (isSuccess) {
          _showSuccessMinimal();
        } else {
          _showError('Save failed: ${result.toString()}');
        }
      } else {
        _showError('Failed to save to Photos');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in saveDirectlyToPhotos: $e');
      debugPrint('StackTrace: $stackTrace');
      _showError('Failed to save: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Capture on mobile using Screenshot package
  Future<Uint8List?> _captureMobile() async {
    if (kIsWeb) return null;

    try {
      return await _currentController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 100),
      );
    } catch (e) {
      debugPrint('Error capturing mobile: $e');
      return null;
    }
  }

  // Download image on web
  Future<void> _downloadImageWeb(Uint8List imageBytes) async {
    if (!kIsWeb) return;

    final filename = 'slowpanda_${DateTime.now().millisecondsSinceEpoch}.png';
    WebDownload.downloadImage(imageBytes, filename);
  }

  // Save and share on mobile
  Future<void> _saveAndShareMobile(Uint8List imageBytes) async {
    if (kIsWeb) return;

    try {
      // Use application documents directory (more reliable in TestFlight)
      final tempDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'kalmfupanda_$timestamp.png';
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(imageBytes);

      debugPrint('Sharing file: ${file.path}');

      // Show native share sheet with shareText for better compatibility
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'KalmFu Panda Quote',
        text: '"${widget.quote.text}" — ${widget.quote.author}',
      );

      // Check if share was completed
      debugPrint('Share result: ${result.status}');

      // Clean up the file after sharing
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Failed to delete temp file: $e');
      }

      if (result.status == ShareResultStatus.success) {
        _showSuccessMinimal();
      }
    } catch (e, stackTrace) {
      debugPrint('Error in saveAndShareMobile: $e');
      debugPrint('StackTrace: $stackTrace');
      _showError('Failed to share: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMinimal() {
    if (!mounted) return;
    // Show minimal popup
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => _MinimalSuccessPopup(
        onDismiss: () => Navigator.pop(context),
      ),
    );

    // Auto-dismiss after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }
}

// Minimal success popup widget
class _MinimalSuccessPopup extends StatelessWidget {
  final VoidCallback onDismiss;

  const _MinimalSuccessPopup({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(color: Colors.black26),
          // Centered checkmark
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.accentGold,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
