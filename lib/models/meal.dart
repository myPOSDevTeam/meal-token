 class StaffMealCardResult {
  StaffMealCardResult({this.success, this.mealcardItems, this.message});

  StaffMealCardResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
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
      data['data'] =
          mealcardItems?.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffMealCardItem {
  StaffMealCardItem({this.mealID, this.mealName, this.mealfromTime, this.mealisEligible,this.mealtoTime});

  StaffMealCardItem.fromJson(Map<String, dynamic> json) {
    //txNo = json['tx_no'];
    mealID= json['mealID'];
    mealName = json['mealName'];
    mealfromTime = json['fromTime'];
    mealtoTime  = json['toTime'];
    mealisEligible = json['isEligible'];
    //priceMode = json['price_mode'];
  }

  //String? txNo;
  String? mealID;
  String? mealName;
  String? mealfromTime;
  String? mealtoTime ;
  bool? mealisEligible;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealID;
    data['mealName'] = mealName;
    data['mealfromTime'] = mealfromTime;
    data['toTime'] = mealtoTime;
    data['isEligible'] = mealisEligible;
    return data;
  }
}

//   //String? txNo;
//   String? mealID;
//   String? mealName;
//   DateTime? mealfromTime;
//   DateTime? mealtoTime ;
//   bool? mealisEligible;


//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     ///data['tx_no'] = txNo;
//     data['mealID'] = mealID;
//     data['mealName'] = mealName;
//     data['mealfromTime'] = mealfromTime;
//     data['toTime'] = mealtoTime;
//     data['isEligible'] = mealisEligible;
//     //data['price_mode'] = priceMode;
//     return data;
//   }
// }
