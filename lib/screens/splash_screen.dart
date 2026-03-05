import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_logo.dart';
import 'quote_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
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

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start animations
    _animationController.forward();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted && !_hasNavigated) {
        _navigateToQuoteScreen();
      }
    });
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PandaLogo(size: 120),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeInAnimation,
                child: RichText(
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
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Text(
                  'words worth pausing for',
                  style: AppTextStyles.uiLabel.copyWith(
                    color: const Color(0xFF444444),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
