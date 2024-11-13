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
                  confirmPositionLeft
                      ? _buildConfirmBtn(confirmText, onConfirm)
                      : _buildCancelBtn(text: cancelText, onTap: onCancel),
                  const SizedBox(width: 16),
                  confirmPositionLeft
                      ? _buildCancelBtn(text: cancelText, onTap: onCancel)
                      : _buildConfirmBtn(confirmText, onConfirm),
                ] else ...[
                  _buildConfirmBtn(confirmText, onConfirm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditNameDialog extends StatelessWidget {
  EditNameDialog({super.key, required this.onSubmit});

  final Function(String) onSubmit;

  final TextEditingController _controller = TextEditingController();
  final noBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
        bgColor: UiColors.c23242A,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'changeName'.tr,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  maxLines: 1,
                  controller: _controller,
                  cursorColor: UiColors.cDBFFFFFF,
                  style: TextStyle(
                      color: UiColors.cDBFFFFFF,
                      fontSize: 14,
                      fontWeight: FontWeightExt.medium),
                  decoration: InputDecoration(
                      hintText: 'changeName'.tr,
                      hintStyle: TextStyle(
                          color: UiColors.c61FFFFFF,
                          fontSize: 14,
                          fontWeight: FontWeightExt.medium),
                      fillColor: UiColors.c121212,
                      border: noBorder,
                      enabledBorder: noBorder,
                      focusedBorder: noBorder,
                      filled: true),
                ),
              ),
            ),
            Row(
              children: [
                _buildCancelBtn(),
                const SizedBox(
                  width: 16,
                ),
                _buildConfirmBtn('submit'.tr, () {
                  if (_controller.text.isEmpty) {
                    return;
                  }
                  onSubmit.call(_controller.text);
                })
              ],
            )
          ],
        ));
  }
}

Expanded _buildCancelBtn({String? text, VoidCallback? onTap}) {
  return Expanded(
    child: CustomButton(
      height: 44,
      width: double.infinity,
      onTap: onTap ?? () => Get.back(),
      text: text ?? 'cancel'.tr,
      textColor: UiColors.cDBFFFFFF,
      bgColor: UiColors.c30333F,
      borderRadius: 12,
    ),
  );
}

Expanded _buildConfirmBtn(String text, VoidCallback? onTap) {
  return Expanded(
    child: CustomButton(
      height: 44,
      width: double.infinity,
      onTap: onTap,
      text: text,
      textColor: UiColors.cDBFFFFFF,
      bgColors: const [UiColors.c7631EC, UiColors.cBC8EF5],
      borderRadius: 12,
    ),
  );
}

class DialogContainer extends StatelessWidget {
  const DialogContainer(
      {super.key, required this.child, this.bgColor = UiColors.c262434});

  final Widget child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Material(
        color: Colors.transparent,
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
