import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int totalFrames = 8;

  @override
  void initState() {
    super.initState();

    // 🎬 Total animation duration (controls speed)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 🔥 adjust here
    )..repeat();

    // ⏳ Navigate after 4 sec
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
          // 🌈 Gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primaryLight,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 🧘 Animated Monk (smooth)
          Positioned.fill(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.onPrimary, AppColors.primaryDark],
                    ).createShader(bounds),
                    child: Text(
                      "Inner Monk",
                      style: AppTypography.heading1.copyWith(
                        fontFamily: 'Baloo',
                        color: AppColors.onPrimary,
                        fontSize: 38,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Image.asset(
                        'assets/mascots/frame$currentFrame.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                        gaplessPlayback: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}