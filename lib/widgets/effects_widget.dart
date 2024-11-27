import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/controllers/create_controller.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../common/ui_colors.dart';

class EffectsWidget extends StatefulWidget {
  const EffectsWidget(
      {super.key,
      required this.model,
      required this.onTap,
      this.padding,
      this.containerRadius,
      this.videoRadius,
      this.textSize,
      this.selectedColor,
      this.fromHome = true,
      this.unSelectedColor});

  final EffectsModel model;
  final Function(EffectsModel model) onTap;
  final double? padding;
  final double? containerRadius;
  final double? videoRadius;
  final double? textSize;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final bool fromHome;

  @override
  State<EffectsWidget> createState() => _EffectsWidgetState();
}

class _EffectsWidgetState extends State<EffectsWidget>
    with WidgetsBindingObserver {
  final CreateController _createCtr = Get.find<CreateController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap.call(widget.model);
      },
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
              color: widget.unSelectedColor ?? UiColors.c23242A,
              borderRadius: BorderRadius.circular(widget.containerRadius ?? 16),
              border: Border.all(
                  color: _createCtr.curEffects.value == widget.model
                      ? widget.selectedColor ?? Colors.transparent
                      : widget.unSelectedColor ?? Colors.transparent,
                  width: 1.5)),
          padding: EdgeInsets.all(widget.padding ?? 8.0),
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Positioned.fill(
                      child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(widget.videoRadius ?? 8),
                    child: CachedNetworkImage(
                      imageUrl: widget.model.imageUrl ?? "",
                      fit: BoxFit.cover,
                    ),
                  )),
                  if (widget.fromHome)
                    Positioned(
                      right: 4,
                      bottom: 6,
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(8),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        bgColor: UiColors.cB8000000,
                        text: 'tryIt'.tr,
                        textColor: Colors.white,
                        textSize: 10,
                        leftIcon: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Image.asset(
                              'images/icon/ic_effects_unselected.png',
                              width: 16,
                            )),
                      ),
                    )
                ],
              )),
              SizedBox(
                height: widget.padding ?? 8,
              ),
              Text(
                widget.model.tag ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: _createCtr.curEffects.value == widget.model
                        ? widget.selectedColor ?? Colors.white
                        : Colors.white,
                    fontSize: widget.textSize ?? 12,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
