class StaffMealCardResult {
  StaffMealCardResult({this.success, this.mealcardItems, this.message});

  StaffMealCardResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
   // status = json['status'];
    if (json['data'] != null) {
      mealcardItems = <StaffMealCardItem>[];
      json['data'].forEach((dynamic v) {
        mealcardItems?.add(StaffMealCardItem.fromJson(v));
      });
    }
  }
/////
  bool? success;
  List<StaffMealCardItem>? mealcardItems;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = message;
    if (mealcardItems != null) {
      data['data'] = mealcardItems?.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

// class StaffMealCardItem {
  
//   String? mealID;
//   String? mealName;
//   String? mealfromTime;
//   String? mealtoTime;
//   bool? mealisEligible;
//   bool? isMealProvided;

//   StaffMealCardItem(
//       {this.mealID,
//       this.mealName,
//       this.mealfromTime,
//       this.mealisEligible,
//       this.mealtoTime,
//       this.isMealProvided});

//   StaffMealCardItem.fromJson(Map<String, dynamic> json) {
//     //txNo = json['tx_no'];
//     mealID = json['mealID'];
//     mealName = json['mealName'];
//     mealfromTime = json['fromTime'];
//     mealtoTime = json['toTime'];
//     mealisEligible = json['isEligible'];
//     isMealProvided = json['isMealProvided'];

//     //priceMode = json['price_mode'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['mealID'] = mealID;
//     data['mealName'] = mealName;
//     data['mealfromTime'] = mealfromTime;
//     data['toTime'] = mealtoTime;
//     data['isEligible'] = mealisEligible;
//     return data;
//   }
// }
class StaffMealCardItem {
  String? mealID;
  String? mealName;
  String? mealfromTime;
  String? mealtoTime;
  bool? mealisEligible;
  bool? isMealProvided;
  int? status;
  String? message;

  StaffMealCardItem({
    this.mealID,
    this.mealName,
    this.mealfromTime,
    this.mealtoTime,
    this.mealisEligible,
    this.isMealProvided,
    this.status,
    this.message,
  });

  StaffMealCardItem.fromJson(Map<String, dynamic> json) {
    mealID = json['mealID'];
    mealName = json['mealName'];
    mealfromTime = json['fromTime'];
    mealtoTime = json['toTime'];
    mealisEligible = json['isEligible'];
    isMealProvided = json['isMealProvided'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealID;
    data['mealName'] = mealName;
    data['fromTime'] = mealfromTime;
    data['toTime'] = mealtoTime;
    data['isEligible'] = mealisEligible;
    data['isMealProvided'] = isMealProvided;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}


// class MealResponse {
//   final bool success;
//   final String message;
//   final List<Meal> data;

//   MealResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory MealResponse.fromJson(Map<String, dynamic> json) {
//     return MealResponse(
//       success: json['success'],
//       message: json['message'],
//       data: List<Meal>.from(json['data'].map((meal) => Meal.fromJson(meal))),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': List<dynamic>.from(data.map((meal) => meal.toJson())),
//     };
//   }
// }

// class Meal {
//   final int status;
//   final String mealId;
//   final String message;

//   Meal({
//     required this.status,
//     required this.mealId,
//     required this.message,
//   });

//   factory Meal.fromJson(Map<String, dynamic> json) {
//     return Meal(
//       status: json['status'],
//       mealId: json['mealId'],
//       message: json['message'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'mealId': mealId,
//       'message': message,
//     };
//   }
// }