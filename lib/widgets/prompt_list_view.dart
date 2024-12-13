import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/models/example_model.dart';

import '../common/ui_colors.dart';

class PromptListView extends StatefulWidget {
  const PromptListView(
      {super.key,
      required this.dataList,
      this.paddingTop,
      this.onClick,
      this.onItemClick});

  final List<ExampleModel> dataList;
  final double? paddingTop;
  final Function(ExampleModel)? onClick;
  final Function(ExampleModel)? onItemClick;

  @override
  State<PromptListView> createState() => _PromptListViewState();
}

class _PromptListViewState extends State<PromptListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: widget.paddingTop ?? 24.0),
          child: Text(
            'suggestedForYou'.tr,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: widget.dataList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 154 / 190,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 12.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            ExampleModel model = widget.dataList[index];
            return buildEffectsPromptItem(model, operate: 'tryPrompt'.tr,
                onTap: () {
              widget.onClick?.call(model);
            }, onItemClick: () {
              widget.onItemClick?.call(model);
            });
          },
        )
      ],
    );
  }
}

Widget buildEffectsPromptItem(ExampleModel model,
    {String? operate, VoidCallback? onTap, VoidCallback? onItemClick}) {
  return GestureDetector(
    onTap: onItemClick,
    child: Stack(
      children: [
        Positioned.fill(
            child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: UiColors.c23242A,
            child: CachedNetworkImage(
              placeholder: (context, url) => CachedNetworkImage(
                imageUrl: model.thumbnailUrl ?? '',
              ),
              errorWidget: (_, __, ___) => errorView(),
              imageUrl: model.imageUrl ?? "",
              fit: BoxFit.cover,
            ),
          ),
        )),
        Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.transparent, Color(0xCC000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(12)),
        ),
        if (operate?.isNotEmpty ?? false)
          Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                      color: UiColors.cDB000000,
                      borderRadius: BorderRadius.circular(6)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    operate ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              )),
        Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Text(
              (model.isEffects ? model.tag : model.description) ?? "",
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )),
        if (model.isRepaired ?? false) Positioned.fill(child: repairedView())
      ],
    ),
  );
}

Widget repairedView({bool isLittle = false}) {
  return Container(
    decoration: BoxDecoration(
        color: UiColors.c66000000,
        borderRadius: BorderRadius.circular(isLittle ? 6 : 12)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/img_repaired.png",
          width: isLittle ? 32 : 48,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'underMaintenance'.tr,
          style: TextStyle(
              color: UiColors.cDBFFFFFF,
              fontSize: isLittle ? 8 : 10,
              fontWeight: FontWeightExt.semiBold),
        )
      ],
    ),
  );
}

Widget errorView() {
  return Container(
    decoration: BoxDecoration(
        color: UiColors.c23242A, borderRadius: BorderRadius.circular(12)),
    child: Center(
        child: Image.asset(
      'assets/images/img_placeholder.png',
      width: 60,
    )),
  );
}
