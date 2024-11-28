import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_ai/models/effects_model.dart';

import '../common/ui_colors.dart';

class PromptListView extends StatefulWidget {
  const PromptListView(
      {super.key,
      required this.dataList,
      this.paddingTop,
      this.onClick,
      this.onItemClick});

  final List<EffectsModel> dataList;
  final double? paddingTop;
  final Function(EffectsModel)? onClick;
  final Function(EffectsModel)? onItemClick;

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
          padding: const EdgeInsets.only(top: 16),
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
            EffectsModel model = widget.dataList[index];
            return buildEffectsPromptItem(model.imageUrl,
                operate: 'tryPrompt'.tr, onTap: () {
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

Widget buildEffectsPromptItem(String? imageUrl,
    {String? name,
    String? operate,
    VoidCallback? onTap,
    VoidCallback? onItemClick}) {
  return GestureDetector(
    onTap: onItemClick,
    child: Stack(
      children: [
        Positioned.fill(
            child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            placeholder: (context, url) => placeholderView(),
            imageUrl: imageUrl ?? "",
            fit: BoxFit.cover,
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
            child: Text(
              name ?? "",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )),
      ],
    ),
  );
}

Widget placeholderView() {
  return Container(
    decoration: BoxDecoration(
        color: UiColors.c23242A, borderRadius: BorderRadius.circular(12)),
    child: Center(
        child: Image.asset(
      'images/icon/img_placeholder.png',
      width: 60,
    )),
  );
}
