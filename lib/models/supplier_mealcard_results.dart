
  class MealCardResult {
  MealCardResult({this.success, this.mealcardItems, this.message});

  MealCardResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
    if (json['data'] != null) {
      mealcardItems = <MealCardItem>[];
      json['data'].forEach((dynamic v) {
        mealcardItems?.add(MealCardItem.fromJson(v));
      });
    }
  }
/////
  bool? success;
  List<MealCardItem>? mealcardItems;
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

class MealCardItem {

  MealCardItem({this.mealID, this.mealName, this.mealfromTime, this.mealisEligible,this.mealtoTime, this.mealisProvided});

    MealCardItem.fromJson(Map<String, dynamic> json) {
    //txNo = json['tx_no'];
    mealID= json['mealID'];
    mealName = json['mealName'];
    mealfromTime = json['fromTime'];
    mealtoTime  = json['toTime'];
    mealisEligible = json['isEligible'];
    mealisProvided = json['isMealProvided'];

    //priceMode = json['price_mode'];
  }

  //String? txNo;
  String? mealID;
  String? mealName;
  String? mealfromTime;
  String? mealtoTime ;
  bool? mealisEligible;
  bool? mealisProvided;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealID;
    data['mealName'] = mealName;
    data['mealfromTime'] = mealfromTime;
    data['toTime'] = mealtoTime;
    data['isEligible'] = mealisEligible;
    data['isMealProvided'] = mealisEligible;
    return data;
  }

}



