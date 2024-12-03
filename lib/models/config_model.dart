class ConfigModel {
  String limitedOfferPopup;
  String? creationLayoutSwitch; //  1：开启兜底方案 ， 0：关闭兜底方案。 默认为0
  String jumpConfig;

  ConfigModel({
    required this.limitedOfferPopup,
    required this.creationLayoutSwitch,
    required this.jumpConfig,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        limitedOfferPopup: json["limited_offer_popup"],
        creationLayoutSwitch: json["creation_layout_switch"],
        jumpConfig: json["jump_config"],
      );
}
