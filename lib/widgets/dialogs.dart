import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/common/ui_colors.dart';

import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.subText,
    required this.confirmText,
    this.cancelText,
    this.icon,
    this.onConfirm,
    this.onCancel,
    this.confirmPositionLeft = false,
  });

  final String title;
  final String? subText;
  final String confirmText;
  final Function()? onConfirm;
  final String? cancelText;
  final Function()? onCancel;
  final Widget? icon;
  final bool confirmPositionLeft;

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeightExt.bold,
              decoration: TextDecoration.none,
            ),
          ),
          if (icon != null) icon!,
          if (subText != null)
            Text(
              subText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UiColors.c61FFFFFF,
                fontSize: 14,
                fontWeight: FontWeightExt.medium,
                decoration: TextDecoration.none,
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                if (cancelText != null) ...[
                  confirmPositionLeft ? _buildConfirmBtn() : _buildCancelBtn(),
                  const SizedBox(width: 16),
                  confirmPositionLeft ? _buildCancelBtn() : _buildConfirmBtn(),
                ] else ...[
                  _buildConfirmBtn(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildCancelBtn() {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: CustomButton(
          onTap: onCancel ?? () => Get.back(),
          text: cancelText!,
          textColor: UiColors.cDBFFFFFF,
          bgColor: UiColors.c30333F,
          borderRadius: 12,
        ),
      ),
    );
  }

  Expanded _buildConfirmBtn() {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: CustomButton(
          onTap: onConfirm,
          text: confirmText,
          textColor: UiColors.cDBFFFFFF,
          bgColors: const [UiColors.c7631EC, UiColors.cBC8EF5],
          borderRadius: 12,
        ),
      ),
    );
  }
}

class DialogContainer extends StatelessWidget {
  const DialogContainer(
      {super.key, required this.child, this.bgColor = UiColors.c262434});

  final Widget child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        width: Get.width - 48,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// 底部弹出
///
/// Example:
/// ```
/// Get.bottomSheet(
///    BottomPopOptions(children:[])
///)
/// ```
class BottomPopOptions extends StatelessWidget {
  const BottomPopOptions({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 40),
      decoration: const ShapeDecoration(
        color: UiColors.cBC8EF5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const ImageIcon(
                  AssetImage('images/icon/close.png'),
                  size: 24,
                  color: UiColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
