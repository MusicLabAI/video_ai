class JumpConfigModel {
  final int? coverType; // 封面类型
  final int? targetType; // 跳转目标类型
  final String? coverUrl; // 封面图片 URL
  final String? target; // 跳转目标
  final String? title; // 标题
  final String? description; // 描述
  final bool? enTry; // 是否启用尝试（可选字段）
  final int? exampleId; // 示例ID（可选字段）

  // 构造函数
  JumpConfigModel({
    this.coverType,
    this.targetType,
    this.coverUrl,
    this.target,
    this.title,
    this.description,
    this.enTry,
    this.exampleId,
  });

  // 将 JSON 转换为 JumpConfigModel 对象
  factory JumpConfigModel.fromJson(Map<String, dynamic> json) {
    return JumpConfigModel(
      coverType: json['coverType'] as int?,
      targetType: json['targetType'] as int?,
      coverUrl: json['coverUrl'] as String?,
      target: json['target'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      enTry: json['enTry'] as bool?,
      exampleId: json['effectId'] as int?,
    );
  }

  // 将 JumpConfigModel 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'coverType': coverType,
      'targetType': targetType,
      'coverUrl': coverUrl,
      'target': target,
      'title': title,
      'description': description,
      'enTry': enTry,
      'effectId': exampleId,
    };
  }

  // 创建副本方法，用于修改部分字段
  JumpConfigModel copyWith({
    int? coverType,
    int? targetType,
    String? coverUrl,
    String? target,
    String? title,
    String? description,
    bool? enTry,
    int? effectId,
  }) {
    return JumpConfigModel(
      coverType: coverType ?? this.coverType,
      targetType: targetType ?? this.targetType,
      coverUrl: coverUrl ?? this.coverUrl,
      target: target ?? this.target,
      title: title ?? this.title,
      description: description ?? this.description,
      enTry: enTry ?? this.enTry,
      exampleId: effectId ?? this.exampleId,
    );
  }

  // 重写 toString 方法，方便调试
  @override
  String toString() {
    return 'JumpConfigModel(coverType: $coverType, targetType: $targetType, coverUrl: $coverUrl, target: $target, title: $title, description: $description, enTry: $enTry, effectId: $exampleId)';
  }
}

