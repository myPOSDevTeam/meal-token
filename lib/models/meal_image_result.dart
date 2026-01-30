class ImageResult {
  ImageResult({this.success, this.imageItems, this.message});

  ImageResult.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['msg'];
    if (json['data'] != null) {
      imageItems = <ImageItem>[];
      json['data'].forEach((dynamic v) {
        imageItems?.add(ImageItem.fromJson(v));
      });
    }
  }
/////
  bool? success;
  List<ImageItem>? imageItems;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = message;
    if (imageItems != null) {
      data['data'] = imageItems?.map((dynamic v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageItem {
  String? mealID;
  String? mealName;
  String? mealfromTime;
  String? mealtoTime;
  String? mealDescription;
  String? mealImage;

  ImageItem({
    this.mealID,
    this.mealName,
    this.mealfromTime,
    this.mealtoTime,
    this.mealDescription,
    this.mealImage,
  });

  ImageItem.fromJson(Map<String, dynamic> json) {
    //txNo = json['tx_no'];
    mealID = json['mealID'];
    mealName = json['mealName'];
    mealfromTime = json['fromTime'];
    mealtoTime = json['toTime'];
    mealDescription = json['mealDescription'];
    mealImage = json['mealImage'];

    //priceMode = json['price_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealID'] = mealID;
    data['mealName'] = mealName;
    data['mealfromTime'] = mealfromTime;
    data['toTime'] = mealtoTime;
    data['mealDescription'] = mealDescription;
    data['mealImage'] = mealImage;
    return data;
  }
}
