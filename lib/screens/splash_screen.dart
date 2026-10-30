import 'dart:async';
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  final AppState appState;

  const SplashScreen({super.key, required this.appState});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    // Auto-transition to main shell after 2.3 seconds
    _navTimer = Timer(const Duration(milliseconds: 2300), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (!mounted) return;
    _navTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            MainShell(appState: widget.appState),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: InkWell(
        onTap: _navigateToHome, // Tap anywhere to skip splash
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Radial Emerald Glow Background
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricMint.withOpacity(0.18),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Center Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3D Glowing App Icon
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(38),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.electricMint.withOpacity(0.4),
                              blurRadius: 36,
                              spreadRadius: 4,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(38),
                          child: Image.asset(
                            'assets/images/plugmitra_logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback vector icon if asset loading
                              return Container(
                                color: AppTheme.cardDark,
                                child: const Icon(Icons.bolt, size: 80, color: AppTheme.electricMint),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Tagline matching Screen 1 & 2
                      const Text(
                        'Charge Smarter. Go Greener.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find. Book. Charge. Pay.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.electricMint,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Loader & Footer
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.electricMint),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco, size: 12, color: AppTheme.electricMint),
                      const SizedBox(width: 4),
                      Text(
                        'Universal EV Mobility Platform',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textMuted.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
