import 'package:flutter/material.dart';
import 'package:video_ai/common/ui_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    required this.textColor,
    this.textSize,
    this.bgColor,
    this.bgColors,
    this.width,
    this.height,
    this.leftIcon,
    this.rightIcon,
    this.borderRadius,
    this.contentPadding,
    this.margin,
    this.border,
  });

  final List<Color>? bgColors;
  final Color? bgColor;
  final String text;
  final Color textColor;
  final double? textSize;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double? width;
  final double? height;
  final Function()? onTap;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: contentPadding,
        margin: margin,
        decoration: BoxDecoration(
          color: bgColors != null ? null : bgColor,
          gradient: bgColors == null
              ? null
              : LinearGradient(
                  colors: bgColors!,
                ),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          border: border
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftIcon != null) leftIcon!,
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: textSize ?? 16,
                  fontWeight: FontWeightExt.semiBold,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            if (rightIcon != null) rightIcon!,
          ],
        ),
      ),
    );
  }
}
