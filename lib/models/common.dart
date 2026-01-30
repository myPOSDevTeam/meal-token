import 'dart:async';

import 'package:jkh_mealtoken/controllers/api_client.dart';
import 'package:jkh_mealtoken/models/meal_image_result.dart';

class COMMON {
  static String HTTP_BASE = ApiClient.baseURL;
  //Replace with our own API
  static String MOBILE = '';
  static String ROLE = '';
  static String NAME = '';
  static String USERID = '';
  // static Timer? timer;
  static String userImageByte = '';
  static ImageResult? allMeals;

  static String splitPharagraph(String paragraph, int splitlenght) {
    int lenghtOfPharagraph = paragraph.length;
    int lineCount = ((lenghtOfPharagraph - (lenghtOfPharagraph % splitlenght)) /
            splitlenght)
        .round();
    String newparagraph = '';

    if (lenghtOfPharagraph <= splitlenght) {
      return paragraph;
    }

    for (int singleline = 0; singleline < lineCount; singleline++) {
      newparagraph += '\n' +
          paragraph.substring(
              singleline * splitlenght, ((singleline + 1) * splitlenght));
    }

    return newparagraph;
  }

  static String setLineBreakerToSqlString(String sqlString) {
    return sqlString.trim().replaceAll("*", "\n");
  }
}
