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
  String? imageUrl;
  String? videoUrl;
  String? videoFirstFrame;
  int? status;

  EffectsModel({
    this.id,
    this.tag,
    this.value,
    this.imageUrl,
    this.videoUrl,
    this.videoFirstFrame,
    this.status,
  });

  factory EffectsModel.fromJson(Map<String, dynamic> json) => EffectsModel(
    id: json["id"],
    tag: json["tag"],
    value: json["value"],
    imageUrl: json["imageUrl"],
    videoUrl: json["videoUrl"],
    videoFirstFrame: json["videoFirstFrame"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag": tag,
    "value": value,
    "imageUrl": imageUrl,
    "videoUrl": videoUrl,
    "videoFirstFrame": videoFirstFrame,
    "status": status,
  };
}