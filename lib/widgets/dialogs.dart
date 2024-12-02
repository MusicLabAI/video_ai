import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_ai/common/ui_colors.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/widgets/effects_widget.dart';

import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.subText,
    this.subTextPadding,
    required this.confirmText,
    this.cancelText,
    this.icon,
    this.onConfirm,
    this.onCancel,
    this.confirmPositionLeft = false,
  });

  final String title;
  final String? subText;
  final EdgeInsetsGeometry? subTextPadding;
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
            Padding(
              padding: subTextPadding ?? const EdgeInsets.all(0),
              child: Text(
                subText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: UiColors.c61FFFFFF,
                  fontSize: 14,
                  fontWeight: FontWeightExt.medium,
                  decoration: TextDecoration.none,
                ),
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              child: TextField(
                maxLines: 1,
                controller: _controller,
                cursorColor: UiColors.cDBFFFFFF,
                maxLength: 15,
                style: TextStyle(
                    color: UiColors.cDBFFFFFF,
                    fontSize: 14,
                    fontWeight: FontWeightExt.medium),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 12),
                  hintText: 'changeName'.tr,
                  hintStyle: TextStyle(
                      color: UiColors.c61FFFFFF,
                      fontSize: 14,
                      fontWeight: FontWeightExt.medium),
                  counterStyle:
                      const TextStyle(color: UiColors.c61FFFFFF, fontSize: 12),
                  fillColor: UiColors.c121212,
                  filled: true,
                  border: noBorder,
                  enabledBorder: noBorder,
                  focusedBorder: noBorder,
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
                  AssetImage('assets/images/close.png'),
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

class EffectDialog extends StatefulWidget {
  const EffectDialog({super.key});

  @override
  State<EffectDialog> createState() => _EffectDialogState();
}

class _EffectDialogState extends State<EffectDialog> {
  final CreateController _createCtr = Get.find<CreateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            color: UiColors.c23242A,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.only(left: 24, top: 16, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'effect'.tr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/ic_close.png',
                          width: 24,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                height: 342,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: [
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                          childCount: _createCtr.effectsList.length,
                          (BuildContext context, int index) {
                        return EffectsWidget(
                          model: _createCtr.effectsList[index],
                          containerRadius: 12,
                          isShowTry: false,
                          innerRadius: 6,
                          padding: 6,
                          textSize: 10,
                          unSelectedColor: UiColors.c1B1B1F,
                          selectedColor: UiColors.cBC8EF5,
                          onTry: (model) {
                            _createCtr.selectEffects(model);
                            Get.back();
                          },
                        );
                      }),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 116,
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 12,
                              childAspectRatio: 116 / 160),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        width: 24,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

Widget getRequestPermissionDialog(String desc) {
  return CustomDialog(
    title: 'photoLibraryTitle'.tr,
    subText: desc,
    subTextPadding: const EdgeInsets.only(top: 12),
    cancelText: 'cancel'.tr,
    confirmText: 'settingsButton'.tr,
    onConfirm: () async {
      Get.back();
      await openAppSettings();
    },
  );
}

Widget deleteConfirmDialog(VoidCallback onDelete) {
  return CustomDialog(
    title: 'confirmDeletion'.tr,
    icon: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Image.asset(
        'assets/images/ic_delete_big.png',
        width: 70,
        height: 70,
      ),
    ),
    confirmText: 'delete'.tr,
    cancelText: 'cancel'.tr,
    onConfirm: () async {
      Get.back();
      onDelete.call();
    },
  );
}
