class ParameterModel {
  final String name;
  final dynamic value;
  final String icon;

  ParameterModel({
    required this.name,
    required this.value,
    required this.icon,
  });

  @override
  String toString() {
    return 'ParameterModel(name: $name, value: $value, icon: $icon)';
  }
}
