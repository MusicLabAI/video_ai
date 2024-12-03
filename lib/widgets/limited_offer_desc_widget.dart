import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../common/ui_colors.dart';
import '../models/shop_model.dart';

class LimitedOfferDescWidget extends StatelessWidget {
  const LimitedOfferDescWidget({super.key, required this.shopModel});

  final ShopModel shopModel;

  @override
  Widget build(BuildContext context) {
    final String creditsText = "${shopModel.point}";
    final String videoText = "${shopModel.videoNumber}";
    final String priceText = "unitPrice".trArgs([
      shopModel.getUnitPrice(
          shopModel.productDetails?.price ?? "", shopModel.videoNumber ?? 1)
    ]);
    final String desc =
        "limitedOfferGoodDesc".trArgs([creditsText, videoText, priceText]);
    return Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
            children: _buildStyledText(desc,
                [RegExp(r"\b" + RegExp.escape(creditsText) + r"\b"), RegExp(r"\b" + RegExp.escape(priceText) + r"\b")])));
  }

  // 动态生成文本和对应的样式
  List<TextSpan> _buildStyledText(String text, List<RegExp> regexPatterns) {
    List<TextSpan> textSpans = [];
    int currentIndex = 0;

    try {
      // 遍历文本
      while (currentIndex < text.length) {
        bool matched = false;

        // 遍历所有的正则表达式
        for (final regex in regexPatterns) {
          final match = regex.matchAsPrefix(text, currentIndex);

          if (match != null) {
            print("匹配");
            // 如果匹配到文本，添加变色部分
            textSpans.add(TextSpan(
              text: match.group(0),
              style: const TextStyle(color: UiColors.c7631EC, fontSize: 14),
            ));
            currentIndex = match.end;
            matched = true;
            break; // 找到一个匹配项后跳出当前循环
          }
        }

        // 如果没有匹配到任何正则表达式，使用默认样式
        if (!matched) {
          textSpans.add(TextSpan(
            text: text[currentIndex],
            style: const TextStyle(color: UiColors.cDBFFFFFF, fontSize: 14),
          ));
          currentIndex++;
        }
      }
    } catch (e) {
      textSpans.add(TextSpan(
        text: text,
        style: const TextStyle(color: UiColors.cDBFFFFFF, fontSize: 14),
      ));
    }
    return textSpans;
  }
}
