import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int totalFrames = 8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get currentFrame {
    final progress = _controller.value;
    return (progress * totalFrames).floor() % totalFrames + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium deep gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.3, -0.5),
                  radius: 1.5,
                  colors: [
                    AppColors.primaryLight,
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFD6E4FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      "Inner Monk",
                      style: AppTypography.heading1.copyWith(
                        fontFamily: 'Baloo',
                        color: Colors.white,
                        fontSize: 48,
                        letterSpacing: -1,
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Image.asset(
                        'assets/mascots/frame$currentFrame.png',
                        width: MediaQuery.of(context).size.width * 0.55,
                        gaplessPlayback: true,
                      );
                    },
                  ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 1200.ms, curve: Curves.elasticOut).fadeIn(duration: 800.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}