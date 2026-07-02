import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

/// The intro's single CTA: a hairline pill that fills on press,
/// then fires after the morph so the response feels physical.
class IntroButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const IntroButton({super.key, required this.label, required this.onPressed});

  @override
  State<IntroButton> createState() => _IntroButtonState();
}

class _IntroButtonState extends State<IntroButton> {
  bool _pressed = false;

  Future<void> _handleTap() async {
    if (_pressed) return;
    setState(() => _pressed = true);
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 260));
    if (mounted) widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          height: 54,
          decoration: BoxDecoration(
            color: _pressed
                ? AppColors.introText
                : AppColors.introText.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: AppColors.introText.withValues(alpha: _pressed ? 0 : 0.26),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: AppTypography.button.copyWith(
              color: _pressed ? AppColors.introInk : AppColors.introText,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
