import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/auth_provider.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/components/app_button.dart';
import '../../../../core/design_system/components/app_card.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isBusy = authState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: Stack(
        children: [
          // Background soft glowing mesh
          Positioned(
            top: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.1, 1.0],
                ),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 4.seconds, curve: Curves.easeInOut),
           
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  
                  // Logo Mark
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppRadius.extraLarge,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.sparkles,
                        color: AppColors.onPrimary,
                        size: 40,
                      ),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(duration: 400.ms),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Typography
                  Text(
                    'Inner Monk',
                    textAlign: TextAlign.center,
                    style: AppTypography.display.copyWith(fontSize: 44, height: 1.1),
                  ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(delay: 100.ms),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  Text(
                    'Your companion on the road to recovery.\nSimple. Secure. Supportive.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
                  ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(delay: 200.ms),
                  
                  const Spacer(),
                  
                  if (authState.error != null) ...[
                    AppCard(
                      color: AppColors.error.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.alertCircle, color: AppColors.error, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              authState.error!,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  
                  // Login Button
                  AppButton(
                    text: 'Continue with Google',
                    isLoading: isBusy,
                    fullWidth: true,
                    icon: LucideIcons.chrome, // Generic substitute for Google
                    onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                  ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Footer
                  Text(
                    'By continuing, you agree to our Terms and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption,
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
