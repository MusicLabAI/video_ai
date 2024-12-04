// To parse this JSON data, do
//
//     final effectsModel = effectsModelFromJson(jsonString);

import 'dart:convert';

EffectsModel effectsModelFromJson(String str) => EffectsModel.fromJson(json.decode(str));

String effectsModelToJson(EffectsModel data) => json.encode(data.toJson());

class EffectsModel {
  int? id;
  String? tag;
  String? value;
  String? thumbnailUrl;
  String? imageUrl;
  String? videoUrl;
  String? videoFirstFrame;
  int? status; // 0 未启用  1 启用  2 维护中

  EffectsModel({
    this.id,
    this.tag,
    this.value,
    this.thumbnailUrl,
    this.imageUrl,
    this.videoUrl,
    this.videoFirstFrame,
    this.status,
  });

  get isRepaired {
   return status == 2;
  }

  factory EffectsModel.fromJson(Map<String, dynamic> json) => EffectsModel(
    id: json["id"],
    tag: json["tag"],
    value: json["value"],
    thumbnailUrl: json["thumbnailUrl"],
    imageUrl: json["imageUrl"],
    videoUrl: json["videoUrl"],
    videoFirstFrame: json["videoFirstFrame"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag": tag,
    "value": value,
    "thumbnailUrl": thumbnailUrl,
    "imageUrl": imageUrl,
    "videoUrl": videoUrl,
    "videoFirstFrame": videoFirstFrame,
    "status": status,
  };
}