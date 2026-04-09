import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum AppButtonVariant { primary, secondary, text, gradient }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.gradient) {
      return _buildGradientButton();
    }

    final isPrimary = variant == AppButtonVariant.primary;
    final isText = variant == AppButtonVariant.text;

    final bgColor = isPrimary ? AppColors.primary : (isText ? Colors.transparent : AppColors.backgroundLight);
    final fgColor = isPrimary ? AppColors.onPrimary : AppColors.textPrimary;

    Widget button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
        elevation: 0,
      ),
      child: _buildChild(fgColor),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildGradientButton() {
    Widget content = InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: AppRadius.extraLarge,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.extraLarge,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.40),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          widthFactor: fullWidth ? null : 1.0,
          child: _buildChild(AppColors.onPrimary),
        ),
      ),
    );

    if (isLoading || onPressed == null) {
      content = Opacity(opacity: 0.5, child: content);
    }
    
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: content);
    }
    return content;
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: AppTypography.button.copyWith(color: color)),
        ],
      );
    }
    return Text(text, style: AppTypography.button.copyWith(color: color));
  }
}
