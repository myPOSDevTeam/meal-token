class UserResult {
  UserResult({this.success, this.message, this.token, this.user});

  UserResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['accessToken'];

    user = json['data'] != null ? User.fromJson(json['data']) : null;
  }

  bool? success;
  String? message;
  String? token;
  User? user;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['accessToken'] = token;
    if (user != null) {
      data['data'] = user?.toJson();
    }
    return data;
  }
}

class User {
  String? userID;
  String? name;
  String? mobile;
  String? role;
  String? departmentId;
  String? departmentName;
  String? otp;
  String? userImage;

  User(
      {this.userID,
      this.name,
      this.mobile,
      this.role,
      this.departmentId,
      this.departmentName,
      this.otp,
      this.userImage});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userID: json['userID'],
      name: json['name'],
      mobile: json['mobile'],
      role: json['role'],
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      otp: json['otp'],
      userImage: json['userImage']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['name'] = name;
    data['mobile'] = mobile;
    data['role'] = role;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['otp'] = otp;
    

    return data;
  }
}
