
class UserInfoModel {
  int? userType;
  int? userId;
  bool? isNew;
  int? expireDate;
  String? name;
  String? email;
  String? token;
  String? userIdText;
  int? expireTime;
  String? expireTimeTips;
  bool? isVip;
  int? point;
  bool? isForever;

  UserInfoModel({
    this.userType,
    this.userId,
    this.isNew,
    this.expireDate,
    this.name,
    this.email,
    this.token,
    this.userIdText,
    this.expireTime,
    this.expireTimeTips,
    this.isVip,
    this.point,
    this.isForever,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        userType: json["userType"],
        userId: json["userId"],
        isNew: json["isNew"],
        expireDate: json["expireDate"],
        email: json["email"],
        name: json["name"],
        token: json["token"],
        userIdText: json["userIdText"],
        expireTime: json["expireTime"],
        expireTimeTips: json["expireTimeTips"],
        isVip: json["isVip"],
        point: json["point"],
        isForever: json["isForever"],
      );

  Map<String, dynamic> toJson() => {
        "userType": userType,
        "userId": userId,
        "isNew": isNew,
        "expireDate": expireDate,
        "email": email,
        "name": name,
        "token": token,
        "userIdText": userIdText,
        "expireTime": expireTime,
        "expireTimeTips": expireTimeTips,
        "isVip": isVip,
        "point": point,
        "isForever": isForever,
      };

  Map<String, dynamic> toMap() {
    return {
      'userType': userType,
      'userId': userId,
      'isNew': isNew,
      'expireDate': expireDate,
      'name': name,
      'email': email,
      'token': token,
      'userIdText': userIdText,
      'expireTime': expireTime,
      'expireTimeTips': expireTimeTips,
      'isVip': isVip,
      'point': point,
      'isForever': isForever,
    };
  }
}
