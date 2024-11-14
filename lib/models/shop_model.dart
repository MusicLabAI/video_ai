import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ShopModel with EquatableMixin {
  @override
  List<Object?> get props => [id];

  final String? remark;
  final int? id;
  final int? point;
  final int? memberType;
  final int? shopType;
  final String? shopId;
  final String? shopName;
  final double? price;
  final String? shopDescribe;
  final bool? selected;
  final int? status;
  ProductDetails? productDetails;
  final bool isInfinitePoint;
  final int? availableSongNumber;
  final bool isForever;
  final int? weekNumber;
  final int? videoNumber;
  final int? badgeType;

  ShopModel({
    this.id,
    this.remark,
    this.point,
    this.memberType,
    this.shopType,
    this.shopId,
    this.shopName,
    this.price,
    this.shopDescribe,
    this.selected = false,
    this.status,
    this.productDetails,
    this.isInfinitePoint = false,
    this.availableSongNumber,
    this.isForever = false,
    this.weekNumber,
    this.videoNumber,
    this.badgeType,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["id"],
        remark: json["remark"],
        point: json["point"],
        memberType: json["memberType"],
        shopType: json["shopType"],
        shopId: json["shopId"],
        shopName: json["shopName"],
        price: json["price"],
        shopDescribe: json["shopDescribe"],
        selected: json["selected"],
        status: json["status"],
        isInfinitePoint: json["isInfinitePoint"] ?? false,
        availableSongNumber: json["availableSongNumber"] ?? 0,
        isForever: json["isForever"] ?? false,
        weekNumber: json["weekNumber"],
        videoNumber: json["videoNumber"],
        badgeType: json["badgeType"],
      );

  String get badgeContent {
    return badgeType == 1 ? 'bestValue'.tr : '';
  }

  String get shopNameLocal {
    if (shopId == "videoai_weekly_subscription" ||
        shopId == "videoai_weekly_subscription_ios") {
      return "weeklyPlanLite".tr;
    }
    if (shopId == "videoai_weekly_subscription_pro" ||
        shopId == "videoai_weekly_subscription_ios_pro") {
      return "weeklyPlanPlus".tr;
    }
    if (shopId == "videoai_yearly_subscription" ||
        shopId == "videoai_yearly_subscription_ios") {
      return "annuallyPlan".tr;
    }
    if (shopId == "videoai_100_credits_videoai" ||
        shopId == "videoai_100_credits_videoai_ios") {
      return "creditsValue".trArgs(['100']);
    }
    if (shopId == "videoai_200_credits_videoai" ||
        shopId == "videoai_200_credits_videoai_ios") {
      return "creditsValue".trArgs(['200']);
    }
    if (shopId == "videoai_500_credits_videoai" ||
        shopId == "videoai_500_credits_videoai_ios") {
      return "creditsValue".trArgs(['500']);
    }
    if (shopId == "videoai_5000_credits_videoai" ||
        shopId == "videoai_5000_credits_videoai_ios") {
      return "creditsValue".trArgs(['5000']);
    }
    return shopName ?? "";
  }

  String get shopDescribeLocal {
    if (shopId == 'videoai_yearly_subscription') {
      return 'yearShopDesc'.trArgs(["${point ?? 0}", "${videoNumber ?? 0}"]);
    }
    if (shopId == "videoai_weekly_subscription" ||
        shopId == "videoai_weekly_subscription_ios" ||
        shopId == "videoai_weekly_subscription_pro" ||
        shopId == "videoai_weekly_subscription_ios_pro") {
      return 'weekShopDesc'.trArgs(["${point ?? 0}", "${videoNumber ?? 0}"]);
    }
    if (shopId == "videoai_100_credits_videoai" ||
        shopId == "videoai_100_credits_videoai_ios" ||
        shopId == "videoai_200_credits_videoai" ||
        shopId == "videoai_200_credits_videoai_ios" ||
        shopId == "videoai_500_credits_videoai" ||
        shopId == "videoai_500_credits_videoai_ios" ||
        shopId == "videoai_5000_credits_videoai" ||
        shopId == "videoai_5000_credits_videoai_ios") {
      return "videoValue".trArgs(["${point ?? 0}"]);
    }
    return shopDescribe ?? "";
  }
}
