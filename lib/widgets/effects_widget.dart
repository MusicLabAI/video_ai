import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/models/effects_model.dart';
import 'package:video_ai/widgets/custom_button.dart';

import '../common/ui_colors.dart';

class EffectsWidget extends StatefulWidget {
  const EffectsWidget(
      {super.key,
      required this.model,
      this.onTry,
      this.onItemClick,
      this.padding,
      this.containerRadius,
      this.innerRadius,
      this.textSize,
      this.selectedColor,
      this.isShowTry = false,
      this.unSelectedColor,
      this.isSelected = false});

  final EffectsModel model;
  final Function(EffectsModel model)? onTry;
  final Function(EffectsModel model)? onItemClick;
  final double? padding;
  final double? containerRadius;
  final double? innerRadius;
  final double? textSize;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final bool isShowTry;
  final bool isSelected;

  @override
  State<EffectsWidget> createState() => _EffectsWidgetState();
}

class _EffectsWidgetState extends State<EffectsWidget>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onItemClick?.call(widget.model);
      },
      child: Container(
          decoration: BoxDecoration(
              color: widget.unSelectedColor ?? UiColors.c23242A,
              borderRadius: BorderRadius.circular(widget.containerRadius ?? 16),
              border: Border.all(
                  color: widget.isSelected
                      ? widget.selectedColor ?? Colors.transparent
                      : widget.unSelectedColor ?? Colors.transparent,
                  width: 2)),
          padding: EdgeInsets.all(widget.padding ?? 8.0),
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Positioned.fill(
                      child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(widget.innerRadius ?? 8),
                    child: CachedNetworkImage(
                      imageUrl: widget.model.imageUrl ?? "",
                      fit: BoxFit.cover,
                    ),
                  )),
                  if (widget.isShowTry)
                    Positioned(
                      right: 4,
                      bottom: 6,
                      child: CustomButton(
                        onTap: () {
                          widget.onTry?.call(widget.model);
                        },
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
                              'assets/images/ic_effects_unselected.png',
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
                    color: widget.isSelected
                        ? widget.selectedColor ?? Colors.white
                        : Colors.white,
                    fontSize: widget.textSize ?? 12,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
    );
  }
}
