import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum AppButtonVariant { primary, secondary, text, gradient, error }

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildButton(context),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (widget.variant == AppButtonVariant.gradient) {
      return _buildGradientButton();
    }

    final isPrimary = widget.variant == AppButtonVariant.primary;
    final isText = widget.variant == AppButtonVariant.text;
    final isError = widget.variant == AppButtonVariant.error;

    final bgColor = isError ? AppColors.error : (isPrimary ? AppColors.primary : (isText ? Colors.transparent : AppColors.backgroundLight));
    final fgColor = isError ? Colors.white : (isPrimary ? AppColors.onPrimary : AppColors.textPrimary);

    Widget button = FilledButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
        elevation: 0,
      ),
      child: _buildChild(fgColor),
    );

    if (widget.fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildGradientButton() {
    Widget content = InkWell(
      onTap: widget.isLoading ? null : widget.onPressed,
      borderRadius: AppRadius.extraLarge,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment(-0.6, -1.0),
            end: Alignment(1.0, 1.0),
          ),
          borderRadius: AppRadius.extraLarge,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 20,
              spreadRadius: -2,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Center(
          widthFactor: widget.fullWidth ? null : 1.0,
          child: _buildChild(AppColors.onPrimary),
        ),
      ),
    );

    if (widget.isLoading || widget.onPressed == null) {
      content = Opacity(opacity: 0.5, child: content);
    }
    
    if (widget.fullWidth) {
      return SizedBox(width: double.infinity, child: content);
    }
    return content;
  }

  Widget _buildChild(Color color) {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(widget.text, style: AppTypography.button.copyWith(color: color)),
        ],
      );
    }
    return Text(widget.text, style: AppTypography.button.copyWith(color: color));
  }
}
