// To parse this JSON data, do
//
//     final effectsModel = effectsModelFromJson(jsonString);

import 'dart:convert';

ExampleModel effectsModelFromJson(String str) => ExampleModel.fromJson(json.decode(str));

String effectsModelToJson(ExampleModel data) => json.encode(data.toJson());

class ExampleModel {
  int? id;
  int? type;
  String? tag;
  String? value;
  String? description;
  String? thumbnailUrl;
  String? imageUrl;
  String? videoUrl;
  String? videoFirstFrame;
  int? status; // 0 未启用  1 启用  2 维护中

  ExampleModel({
    this.id,
    this.type,
    this.tag,
    this.value,
    this.description,
    this.thumbnailUrl,
    this.imageUrl,
    this.videoUrl,
    this.videoFirstFrame,
    this.status,
  });

  get isRepaired {
   return status == 2;
  }

  get isEffects {
    return type == 1;
  }

  factory ExampleModel.fromJson(Map<String, dynamic> json) => ExampleModel(
    id: json["id"],
    type: json["type"],
    tag: json["tag"],
    value: json["value"],
    description: json["description"],
    thumbnailUrl: json["thumbnailUrl"],
    imageUrl: json["imageUrl"],
    videoUrl: json["videoUrl"],
    videoFirstFrame: json["videoFirstFrame"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "tag": tag,
    "value": value,
    "description": description,
    "thumbnailUrl": thumbnailUrl,
    "imageUrl": imageUrl,
    "videoUrl": videoUrl,
    "videoFirstFrame": videoFirstFrame,
    "status": status,
  };
}