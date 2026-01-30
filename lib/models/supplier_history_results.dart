class HistoryCardResult {
  bool? success;
  List<Map<String, dynamic>>? historycardItems;
  String? message;

  HistoryCardResult({this.success, this.historycardItems, this.message});

  HistoryCardResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
    if (json['data'] != null) {
      List<Map<String, dynamic>> summary = [];
      // historycardItems = <HistoryCardItem>[];
      Map<String, dynamic>? map = json['data'];

      map!.forEach(
        (key, value) {
          summary.add({
            "date": key.toString(),
            "value": List.generate(
                value.length, (index) => HistoryCardItem.fromJson(value[index]))
          });
        },
      );
      print(summary);
      historycardItems = summary.reversed.toList();
      // json['data'].forEach((dynamic v) {
      //   historycardItems?.add(HistoryCardItem.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = message;
    if (historycardItems != null) {
      data['data'] = historycardItems?.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryCardItem {
  String? mealID;
  String? mealName;
  String? mealDescription;
  int? mealAllocatedCount;
  int? mealProvidedCount;
  int? staffCount;
  int? temporyCount;

  HistoryCardItem({
    this.mealID,
    this.mealName,
    this.mealDescription,
    this.mealAllocatedCount,
    this.mealProvidedCount,
    this.staffCount,
    this.temporyCount,
  });

  HistoryCardItem.fromJson(Map<String, dynamic> json) {
    mealID = json['mealID'];
    mealName = json['mealName'];
    mealDescription = json['mealDescription'];
    mealAllocatedCount = json['mealAllocatedCount'];
    mealProvidedCount = json['mealProvidedCount'];
    staffCount = json['staffCount'];
    temporyCount = json['temporyCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealID;
    data['mealName'] = mealName;
    data['mealDescription'] = mealDescription;
    data['mealAllocatedCount'] = mealAllocatedCount;
    data['mealProvidedCount'] = mealProvidedCount;
    data['staffCount'] = staffCount;
    data['temporyCount'] = temporyCount;
    return data;
  }
}
