 class MealSummaryResults {
  MealSummaryResults({this.success, this.mealsummaryitems, this.message});

  MealSummaryResults.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
    if (json['data'] != null) {
      mealsummaryitems = <MealSummaryItem>[];
      json['data'].forEach((dynamic v) {
        mealsummaryitems?.add(MealSummaryItem.fromJson(v));
      });
    }
  }
/////
  bool? success;
  List<MealSummaryItem>? mealsummaryitems;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = message;
    if (mealsummaryitems != null) {
      data['data'] =
          mealsummaryitems?.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealSummaryItem {
  MealSummaryItem({this.mealId, this.mealname, this.mealDes, this.mealAllocatedCount,this.mealProvidedCount,this.staffCount, this.temporyCount});

  MealSummaryItem.fromJson(Map<String, dynamic> json) {
    //txNo = json['tx_no'];
    mealId= json['mealID'];
    mealname = json['mealName'];
    mealDes = json['mealDescription'];
    mealAllocatedCount  = json['mealAllocatedCount'];
    mealProvidedCount = json['mealProvidedCount'];
    staffCount = json['staffCount'];
    temporyCount = json['temporyCount'];
  }

  //String? txNo;
  String? mealId;
  String? mealname;
  String? mealDes;
  int? mealAllocatedCount ;
  int? mealProvidedCount;
  int? staffCount;
  int? temporyCount;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealId;
    data['mealName'] = mealname;
    data['mealDescription'] = mealDes;
    data['mealAllocatedCount'] = mealAllocatedCount;
    data['mealProvidedCount'] = mealProvidedCount;
    data['staffCount'] = staffCount;
    data['temporyCount'] = temporyCount;
    return data;
  }
}