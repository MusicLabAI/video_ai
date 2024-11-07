class RecordModel {
  int? createTime;
  DateTime? createTimeText;
  DateTime? createDateText;
  int? updateTime;
  DateTime? updateTimeText;
  DateTime? updateDateText;
  String? remark;
  int? status; // 0 排队 1进行中  2 完成 3失败
  int id;
  String? lumaId;
  int? userId;
  String? outputVideoUrl;
  String? thumbnailUrl;
  String? inputImageUrl;
  int? failureCode; // 1511时 点击toast failureReason
  String? failureReason;
  String? prompt;

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
  });

  bool isCompleted() {
    return status == 2 || status == 3;
  }

  factory RecordModel.fromJson(Map<String, dynamic> json) => RecordModel(
        createTime: json["createTime"],
        createTimeText: json["createTimeText"] == null
            ? null
            : DateTime.parse(json["createTimeText"]),
        createDateText: json["createDateText"] == null
            ? null
            : DateTime.parse(json["createDateText"]),
        updateTime: json["updateTime"],
        updateTimeText: json["updateTimeText"] == null
            ? null
            : DateTime.parse(json["updateTimeText"]),
        updateDateText: json["updateDateText"] == null
            ? null
            : DateTime.parse(json["updateDateText"]),
        remark: json["remark"],
        status: json["status"],
        id: json["id"],
        lumaId: json["lumaId"],
        userId: json["userId"],
        outputVideoUrl: json["outputVideoUrl"],
        thumbnailUrl: json["thumbnailUrl"],
        inputImageUrl: json["inputImageUrl"],
        failureCode: json["failureCode"],
        failureReason: json["failureReason"],
        prompt: json["prompt"],
      );

  Map<String, dynamic> toJson() => {
        "createTime": createTime,
        "createTimeText": createTimeText?.toIso8601String(),
        "createDateText":
            "${createDateText!.year.toString().padLeft(4, '0')}-${createDateText!.month.toString().padLeft(2, '0')}-${createDateText!.day.toString().padLeft(2, '0')}",
        "updateTime": updateTime,
        "updateTimeText": updateTimeText?.toIso8601String(),
        "updateDateText":
            "${updateDateText!.year.toString().padLeft(4, '0')}-${updateDateText!.month.toString().padLeft(2, '0')}-${updateDateText!.day.toString().padLeft(2, '0')}",
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
      };
}
