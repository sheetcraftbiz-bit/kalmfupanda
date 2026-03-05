import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_logo.dart';
import 'quote_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Force dark mode
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // For web, use the video path directly
      // For mobile, use the asset path
      final videoPath = kIsWeb
          ? 'assets/videos/panda_logo.mp4'
          : 'assets/videos/panda_logo.mp4';

      _videoController = VideoPlayerController.asset(
        videoPath,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await _videoController.initialize();
      setState(() {
        _isVideoInitialized = true;
      });

      // Play video
      _videoController.play();

      // Listen for video completion
      _videoController.addListener(_videoListener);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      // If video fails, navigate after delay
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted && !_hasNavigated) {
          _navigateToQuoteScreen();
        }
      });
    }
  }

  void _videoListener() {
    if (_videoController.value.isInitialized &&
        _videoController.value.position >= _videoController.value.duration &&
        !_hasNavigated) {
      _hasNavigated = true;
      _navigateToQuoteScreen();
    }
  }

  void _navigateToQuoteScreen() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const QuoteScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: _isVideoInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              )
            : _isVideoInitialized == false
                ? // Show logo as placeholder while video loads
                _buildFallbackSplash()
                : const SizedBox(),
      ),
    );
  }

  Widget _buildFallbackSplash() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const PandaLogo(size: 120),
        const SizedBox(height: 32),
        RichText(
          text: const TextSpan(
            text: 'slow',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 36,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: 'panda',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 36,
                  color: AppColors.accentGold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'words worth pausing for',
          style: AppTextStyles.uiLabel.copyWith(
            color: const Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}
