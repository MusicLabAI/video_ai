class ParameterModel {
  final String name;
  String? littleName;
  final dynamic value;
  final String icon;
  bool enable;

  ParameterModel({
    required this.name,
    required this.value,
    required this.icon,
    this.enable = true,
    this.littleName
  });

  String get showName {
    return littleName ?? name;
  }

  @override
  String toString() {
    return 'ParameterModel(name: $name, value: $value, icon: $icon, enable: $enable)';
  }
}
