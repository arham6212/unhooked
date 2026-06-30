import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Text(
                'Settings',
                style: AppTypography.heading1.copyWith(
                  height: 1.1, 
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ProfileCard(),
            const SizedBox(height: AppSpacing.xl),
            _SectionLabel('Account'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: LucideIcons.user,
                  label: 'Profile',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: LucideIcons.bell,
                  label: 'Notifications',
                  onTap: () {},
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primary,
                  ),
                ),
                _SettingsTile(
                  icon: LucideIcons.lock,
                  label: 'Privacy',
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionLabel('Support'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: LucideIcons.info,
                  label: 'About Inner Monk',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: LucideIcons.helpCircle,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: LucideIcons.fileText,
                  label: 'Terms & Privacy',
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionLabel('Danger zone'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: LucideIcons.logOut,
                  label: 'Log out',
                  labelColor: AppColors.error,
                  iconColor: AppColors.error,
                  isLast: true,
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.extraLarge,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const streak = 12;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
          ),
          borderRadius: AppRadius.extraLarge,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(LucideIcons.user, color: AppColors.onPrimary, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anonymous',
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Day $streak of recovery',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                    ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 4, 22, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.caption.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.textMuted : AppColors.textMuted,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.labelColor,
    this.iconColor,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? labelColor;
  final Color? iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                  borderRadius: AppRadius.small,
                ),
                child: Icon(icon, size: 16, color: iconColor ?? AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? (isDark ? Colors.white : AppColors.textPrimary),
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: isDark ? AppColors.textMuted : AppColors.textMuted.withValues(alpha: 0.5),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}