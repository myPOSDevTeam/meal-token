class StaffHistoryCardResult {
  StaffHistoryCardResult({this.success, this.staffhistoryItems, this.message});

  StaffHistoryCardResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
    if (json['data'] != null) {
      staffhistoryItems = <StaffHistoryCardItem>[];
      json['data'].forEach((dynamic v) {
        staffhistoryItems?.add(StaffHistoryCardItem.fromJson(v));
      });
     staffhistoryItems= staffhistoryItems!.reversed.toList();
    }
  }
/////
  bool? success;
  List<StaffHistoryCardItem>? staffhistoryItems;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = message;
    if (staffhistoryItems != null) {
      data['data'] = staffhistoryItems?.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffHistoryCardItem {
  String? mealID;
  String? mealName;
  String? mealDescription;
  String? providedDate;

  StaffHistoryCardItem({this.mealID, this.mealName, this.mealDescription});

  StaffHistoryCardItem.fromJson(Map<String, dynamic> json) {
    mealID = json['mealID'];
    mealName = json['mealName'];
    mealDescription = json['mealDescription'];
    providedDate = json['providedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealID;
    data['mealName'] = mealName;
    data['mealDescription'] = mealDescription;
    data['providedDate'] = providedDate;

    return data;
  }
}
