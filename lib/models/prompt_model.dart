import 'dart:convert';

PromptModel promptModelFromJson(String str) => PromptModel.fromJson(json.decode(str));

String promptModelToJson(PromptModel data) => json.encode(data.toJson());

class PromptModel {
  String? prompt;

  PromptModel({
    this.prompt,
  });

  factory PromptModel.fromJson(Map<String, dynamic> json) => PromptModel(
    prompt: json["prompt"],
  );

  Map<String, dynamic> toJson() => {
    "prompt": prompt,
  };
}