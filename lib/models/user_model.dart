class UserInfoModel {
  int? userType;
  int? userId;
  bool? isNew;
  int? expireDate;
  String? email;
  String? token;
  String? userIdText;
  String? expireTimeTips;
  bool? isVip;
  bool? isForever;

  UserInfoModel({
    this.userType,
    this.userId,
    this.isNew,
    this.expireDate,
    this.email,
    this.token,
    this.userIdText,
    this.expireTimeTips,
    this.isVip,
    this.isForever,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        userType: json["userType"],
        userId: json["userId"],
        isNew: json["isNew"],
        expireDate: json["expireDate"],
        email: json["email"],
        token: json["token"],
        userIdText: json["userIdText"],
        expireTimeTips: json["expireTimeTips"],
        isVip: json["isVip"],
        isForever: json["isForever"],
      );

  Map<String, dynamic> toJson() => {
        "userType": userType,
        "userId": userId,
        "isNew": isNew,
        "expireDate": expireDate,
        "email": email,
        "token": token,
        "userIdText": userIdText,
        "expireTimeTips": expireTimeTips,
        "isVip": isVip,
        "isForever": isForever,
      };
}
