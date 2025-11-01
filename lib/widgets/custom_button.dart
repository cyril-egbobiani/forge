import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          elevation: type == ButtonType.primary ? 0 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.md,
            side: type == ButtonType.outline
                ? BorderSide(color: _getBorderColor())
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: _getVerticalPadding(),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: _getIconSize(),
                height: _getIconSize(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _getForegroundColor(),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, SizedBox(width: AppSpacing.sm)],
                  Text(text, style: _getTextStyle()),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.buttonHeightSm;
      case ButtonSize.medium:
        return AppSizes.buttonHeightMd;
      case ButtonSize.large:
        return AppSizes.buttonHeightLg;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.md;
      case ButtonSize.medium:
        return AppSpacing.lg;
      case ButtonSize.large:
        return AppSpacing.xl;
    }
  }

  double _getVerticalPadding() {
    return 0; // Height is controlled by the container
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.iconSm;
      case ButtonSize.medium:
        return AppSizes.iconMd;
      case ButtonSize.large:
        return AppSizes.iconMd;
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.secondary:
        return AppColors.secondary;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.ghost:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.white;
      case ButtonType.secondary:
        return AppColors.white;
      case ButtonType.outline:
        return AppColors.primary;
      case ButtonType.ghost:
        return AppColors.textPrimary;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case ButtonType.outline:
        return AppColors.primary;
      default:
        return Colors.transparent;
    }
  }

  TextStyle _getTextStyle() {
    TextStyle baseStyle;
    switch (size) {
      case ButtonSize.small:
        baseStyle = AppTextStyles.buttonSmall;
        break;
      case ButtonSize.medium:
        baseStyle = AppTextStyles.buttonMedium;
        break;
      case ButtonSize.large:
        baseStyle = AppTextStyles.buttonLarge;
        break;
    }
    return baseStyle.copyWith(color: _getForegroundColor());
  }
}

enum ButtonType { primary, secondary, outline, ghost }

enum ButtonSize { small, medium, large }
