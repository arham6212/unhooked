import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _blobController;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _staggeredAnimations = List.generate(
      6,
      (index) => CurvedAnimation(
        parent: _entranceController,
        curve: Interval(
          index * 0.1,
          (0.6 + (index * 0.1)).clamp(0.0, 1.0),
          curve: Curves.easeOutQuart,
        ),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _blobController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Dynamic Atmospheric Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _blobController,
              builder: (context, child) {
                final t = _blobController.value;
                return Stack(
                  children: [
                    _buildBlob(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      offset: Offset(
                        50 + 40 * (0.5 * (1 + math.sin(t * 2 * math.pi))), 
                        100 + 60 * (0.5 * (1 + math.cos(t * 2 * math.pi + 1.0))),
                      ),
                      size: 300,
                    ),
                    _buildBlob(
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      offset: Offset(
                        -80 + 30 * (0.5 * (1 + math.sin(t * 2 * math.pi + 2.0))),
                        350 + 50 * (0.5 * (1 + math.cos(t * 2 * math.pi))),
                      ),
                      size: 380,
                    ),
                    _buildBlob(
                      color: colorScheme.tertiary.withValues(alpha: 0.08),
                      offset: Offset(
                        220 + 70 * (0.5 * (1 + math.cos(t * 2 * math.pi + 0.5))), 
                        620 + 90 * (0.5 * (1 + math.sin(t * 2 * math.pi))),
                      ),
                      size: 350,
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Foreground Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Minimal Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
                    child: FadeTransition(
                      opacity: _staggeredAnimations[0],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stay Centered',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                            ],
                          ),
                          _buildGlassIconButton(
                            icon: Icons.logout_rounded,
                            onTap: () => ref.read(authProvider.notifier).logout(),
                            colorScheme: colorScheme,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Glass Counter Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: FadeTransition(
                      opacity: _staggeredAnimations[1],
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_staggeredAnimations[1]),
                        child: _buildGlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'DAYS CLEAN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.primary.withValues(alpha: 0.7),
                                  letterSpacing: 2.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 200),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '12',
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: colorScheme.primary,
                                            fontSize: 88,
                                            letterSpacing: -4,
                                          ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bolt_rounded, size: 16, color: colorScheme.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Personal Best: 45 Days',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Modern Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
                    child: FadeTransition(
                      opacity: _staggeredAnimations[2],
                      child: Text(
                        'DAILY FOCUS',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),

                // Staggered Progress Cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      FadeTransition(
                        opacity: _staggeredAnimations[3],
                        child: _buildModernActionCard(
                          context,
                          'Daily Reflection',
                          '3 min meditation',
                          Icons.spa_rounded,
                          colorScheme.primaryContainer.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _staggeredAnimations[4],
                        child: _buildModernActionCard(
                          context,
                          'Community Help',
                          'Connect with a coach',
                          Icons.chat_bubble_outline_rounded,
                          colorScheme.secondaryContainer.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          
          // Minimal FAB
          Positioned(
            bottom: 24,
            right: 24,
            child: FadeTransition(
              opacity: _staggeredAnimations[5],
              child: _buildGlassFAB(
                icon: Icons.add_rounded,
                label: 'Check-in',
                colorScheme: colorScheme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob({required Color color, required Offset offset, required double size}) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
            stops: const [0.5, 1.0],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, double? height, EdgeInsets? padding}) {
    return Container(
      height: height,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: child,
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
      ),
    );
  }

  Widget _buildGlassFAB({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconBg,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return _buildGlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.primary.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
