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
  bool selected;
  final int? status;
  ProductDetails? productDetails;
  final bool isInfinitePoint;
  final int? availableSongNumber;
  final bool isForever;

  ShopModel({
    this.id,
    required this.remark,
    required this.point,
    required this.memberType,
    required this.shopType,
    required this.shopId,
    required this.shopName,
    required this.price,
    required this.shopDescribe,
    required this.selected,
    required this.status,
    this.productDetails,
    this.isInfinitePoint = false,
    this.availableSongNumber,
    this.isForever = false,
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
      );

  String get shopDescribeLocal {
    if (isInfinitePoint) {
      return '∞ ${'lifetimeTips1'.tr}\n∞ ${'lifetimeTips2'.tr}';
    }
    if (shopId == 'MusicLabWeekly') {
      return 'weeklySubscribeTips'.tr;
    }
    if (shopId == 'MusicLabMonthly') {
      return 'monthlySubscribeTips'.tr;
    }
    if (shopId == 'MusicLabYearly') {
      return 'yearlySubscribeTips'.tr;
    }
    if (shopId == 'lifetime') {
      return '$point ${'lifetimeTips1'.tr}\n$availableSongNumber ${'lifetimeTips2'.tr}';
    }
    
    return '';
  }
  
  String get shopCreditsDescribeLocal {
    if (shopId == '18000Credits') {
      return '18000Credits'.tr;
    }
    if (shopId == '1000Credits') {
      return '1000Credits'.tr;
    }
    if (shopId == '300Credits') {
      return '300Credits'.tr;
    }
    if (shopId == '40Credits') {
      return '40Credits'.tr;
    }
    return '';
  }
}
