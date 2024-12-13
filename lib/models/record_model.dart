class RecordModel {
  int? createTime;
  DateTime? createTimeText;
  DateTime? createDateText;
  int? updateTime;
  DateTime? updateTimeText;
  DateTime? updateDateText;
  String? remark;
  int? status; // 0 排队 1进行中 2 完成 3失败
  int id;
  String? lumaId;
  int? userId;
  String? outputVideoUrl;
  String? thumbnailUrl;
  String? inputImageUrl;
  int? failureCode; // 1511时 点击toast failureReason
  String? failureReason;
  String? prompt;
  String? effectText;
  int? effectId;
  String? ratio;
  int? resolution;
  int? duration;
  int? number;

  RecordModel({
    this.createTime,
    this.createTimeText,
    this.createDateText,
    this.updateTime,
    this.updateTimeText,
    this.updateDateText,
    this.remark,
    this.status,
    this.id = -1,
    this.lumaId,
    this.userId,
    this.outputVideoUrl,
    this.thumbnailUrl,
    this.inputImageUrl,
    this.failureCode,
    this.failureReason,
    this.prompt,
    this.effectText,
    this.effectId,
    this.ratio,
    this.resolution,
    this.duration,
    this.number,
  });

  bool isCompleted() {
    return status == 2 || status == 3;
  }

  bool isInProgress() {
    return status == 1;
  }

  factory RecordModel.fromJson(Map<String, dynamic> json) => RecordModel(
    createTime: json["createTime"],
    createTimeText: json["createTimeText"] == null
        ? null
        : DateTime.tryParse(json["createTimeText"] ?? ''),
    createDateText: json["createDateText"] == null
        ? null
        : DateTime.tryParse(json["createDateText"] ?? ''),
    updateTime: json["updateTime"],
    updateTimeText: json["updateTimeText"] == null
        ? null
        : DateTime.tryParse(json["updateTimeText"] ?? ''),
    updateDateText: json["updateDateText"] == null
        ? null
        : DateTime.tryParse(json["updateDateText"] ?? ''),
    remark: json["remark"],
    status: json["status"],
    id: json["id"] ?? -1,
    lumaId: json["lumaId"],
    userId: json["userId"],
    outputVideoUrl: json["outputVideoUrl"],
    thumbnailUrl: json["thumbnailUrl"],
    inputImageUrl: json["inputImageUrl"],
    failureCode: json["failureCode"],
    failureReason: json["failureReason"],
    prompt: json["prompt"],
    effectText: json["effectText"],
    effectId: json["effectId"],
    ratio: json["ratio"],
    resolution: json["resolution"],
    duration: json["duration"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "createTime": createTime,
    "createTimeText": createTimeText?.toIso8601String(),
    "createDateText":
    createDateText != null ? "${createDateText!.year.toString().padLeft(4, '0')}-${createDateText!.month.toString().padLeft(2, '0')}-${createDateText!.day.toString().padLeft(2, '0')}" : null,
    "updateTime": updateTime,
    "updateTimeText": updateTimeText?.toIso8601String(),
    "updateDateText":
    updateDateText != null ? "${updateDateText!.year.toString().padLeft(4, '0')}-${updateDateText!.month.toString().padLeft(2, '0')}-${updateDateText!.day.toString().padLeft(2, '0')}" : null,
    "remark": remark,
    "status": status,
    "id": id,
    "lumaId": lumaId,
    "userId": userId,
    "outputVideoUrl": outputVideoUrl,
    "thumbnailUrl": thumbnailUrl,
    "inputImageUrl": inputImageUrl,
    "failureCode": failureCode,
    "failureReason": failureReason,
    "prompt": prompt,
    "effectText": effectText,
    "effectId": effectId,
    "ratio": ratio,
    "resolution": resolution,
    "duration": duration,
    "number": number,
  };

  RecordModel copyWith({
    int? createTime,
    DateTime? createTimeText,
    DateTime? createDateText,
    int? updateTime,
    DateTime? updateTimeText,
    DateTime? updateDateText,
    String? remark,
    int? status,
    int? id,
    String? lumaId,
    int? userId,
    String? outputVideoUrl,
    String? thumbnailUrl,
    String? inputImageUrl,
    int? failureCode,
    String? failureReason,
    String? prompt,
    String? effectText,
    int? effectId,
    String? ratio,
    int? resolution,
    int? duration,
    int? number,
  }) {
    return RecordModel(
      createTime: createTime ?? this.createTime,
      createTimeText: createTimeText ?? this.createTimeText,
      createDateText: createDateText ?? this.createDateText,
      updateTime: updateTime ?? this.updateTime,
      updateTimeText: updateTimeText ?? this.updateTimeText,
      updateDateText: updateDateText ?? this.updateDateText,
      remark: remark ?? this.remark,
      status: status ?? this.status,
      id: id ?? this.id,
      lumaId: lumaId ?? this.lumaId,
      userId: userId ?? this.userId,
      outputVideoUrl: outputVideoUrl ?? this.outputVideoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      inputImageUrl: inputImageUrl ?? this.inputImageUrl,
      failureCode: failureCode ?? this.failureCode,
      failureReason: failureReason ?? this.failureReason,
      prompt: prompt ?? this.prompt,
      effectText: effectText ?? this.effectText,
      effectId: effectId ?? this.effectId,
      ratio: ratio ?? this.ratio,
      resolution: resolution ?? this.resolution,
      duration: duration ?? this.duration,
      number: number ?? this.number,
    );
  }

  @override
  String toString() {
    return 'RecordModel{id: $id, status: $status, createTimeText: $createTimeText, updateTimeText: $updateTimeText, failureReason: $failureReason}';
  }
}