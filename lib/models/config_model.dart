class ConfigModel {
  int creationLayoutSwitch; //  1：开启兜底方案 ， 0：关闭兜底方案。 默认为0

  ConfigModel({
    required this.creationLayoutSwitch,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        creationLayoutSwitch: json["creation_layout_switch"] ?? 0,
      );
}
