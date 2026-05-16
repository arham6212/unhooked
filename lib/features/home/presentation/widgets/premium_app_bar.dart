import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import 'package:lucide_icons/lucide_icons.dart';
class PremiumAppBar extends StatelessWidget {
  const PremiumAppBar({super.key, 
    required this.onMenu,
    required this.onSos,
    required this.onLogout,
  });

  final VoidCallback onMenu;
  final VoidCallback onSos;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenu,
            icon: Icon(
              LucideIcons.menu,
              color: isDark ? AppColors.textMuted : AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recover Me',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: AppSpacing.sm,
                  height: AppSpacing.sm,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.error,
            borderRadius: AppRadius.circular,
            child: InkWell(
              onTap: onSos,
              borderRadius: AppRadius.circular,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.plus, color: AppColors.onPrimary, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'SOS',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              LucideIcons.moreVertical,
              color: isDark ? AppColors.textMuted : AppColors.textPrimary,
            ),
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(LucideIcons.logOut, size: 20),
                    SizedBox(width: 12),
                    Text('Log out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
