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
    this.icon,
    this.iconRight,
    this.width,
    this.height,
    this.iconWidget,
    this.borderRadius,
  });

  final List<Color>? bgColors;
  final Color? bgColor;
  final String text;
  final Color textColor;
  final double? textSize;
  final String? icon;
  final String? iconRight;
  final Widget? iconWidget;
  final double? width;
  final double? height;
  final Function()? onTap;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 44,
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColors != null ? null : bgColor,
          gradient: bgColors == null
              ? null
              : LinearGradient(
                  colors: bgColors!,
                ),
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              ImageIcon(AssetImage(icon!), color: textColor, size: 20),
            if (iconWidget != null) iconWidget!,
            if (icon != null || iconWidget != null) const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: textSize ?? 16,
                fontWeight: FontWeightExt.semiBold,
                decoration: TextDecoration.none,
              ),
            ),
            if (iconRight != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ImageIcon(AssetImage(iconRight!),
                    color: textColor, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.icon,
      this.iconInLeft = false,
      this.bgColor,
      this.textColor,
      this.textSize,
      this.borderColor,
      this.borderWidth,
      this.radius,
      this.contentPadding,
      this.drawablePadding});

  final String text;
  final Function() onTap;
  final Color? bgColor;
  final Color? textColor;
  final double? textSize;
  final Color? borderColor;
  final double? borderWidth;
  final double? radius;
  final Widget? icon;
  final bool iconInLeft;
  final EdgeInsetsGeometry? contentPadding;
  final double? drawablePadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius ?? 10),
      child: Container(
        padding: contentPadding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: bgColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(radius ?? 10),
            border: Border.all(
                color: borderColor ?? UiColors.cFF30333F,
                width: borderWidth ?? 1)),
        child: Row(
          children: [
            if (icon != null && iconInLeft) icon!,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: drawablePadding ?? 4),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: textSize ?? 10,
                    color: textColor ?? UiColors.c99FFFFFF,
                    fontWeight: FontWeightExt.medium),
              ),
            ),
            if (icon != null && !iconInLeft) icon!,
          ],
        ),
      ),
    );
  }
}
