import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                    Color(0xFF6C4DF6),
                    Color(0xFF8E6BFF),
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
                      colors: [Colors.white, Colors.deepPurple],
                    ).createShader(bounds),
                    child: const Text(
                      "Inner Monk",
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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