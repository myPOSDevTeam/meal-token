import 'package:intl/intl.dart';
import 'package:jkh_mealtoken/controllers/api_client.dart';
import 'package:jkh_mealtoken/models/meal_image_result.dart';
import 'package:jkh_mealtoken/models/meal_summary_results.dart';
import 'package:jkh_mealtoken/models/staff_history_results.dart';
import 'package:jkh_mealtoken/models/staff_mealcard_results.dart';
import 'package:jkh_mealtoken/models/supplier_history_results.dart';
import 'package:jkh_mealtoken/models/supplier_mealcard_results.dart';

class MealController {
  //fetch meal plans
  //here we need to parse staff user id
  Future<MealCardResult?> fetchMealPlans(String userId) async {
    final res = await ApiClient.call('Meal/staff_user/$userId',
        ApiMethod.GET); // 'Meal/staff_user/userID?userID=$userId'

    ///${userId}
    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 &&
        res?.data != null &&
        res?.data['success'] == true) {
      return MealCardResult.fromJson(res!.data);
    } else {
      return null;
    }
  }

  Future<StaffMealCardResult?> fetchStaffMealPlans() async {
    final res = await ApiClient.call('Meal/staff_user', ApiMethod.GET);
    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 &&
        res?.data != null &&
        res?.data['success'] == true) {
      return StaffMealCardResult.fromJson(res!.data);
    } else {
      return null;
    }
  }

  Future<StaffMealCardResult?> updateStaffMealPlan({
    required String? userId,
    required List<String> mealId,
    required String? supplierId,
  }) async {
    final Map<String, dynamic> data = {
      "userId": userId,
      "mealIds":
          List.generate(mealId.length, (index) => {"mealId": mealId[index]}),
      "supplierId": supplierId,
    };

    final res = await ApiClient.call(
        'Meal/update_selected_meal', ApiMethod.POST,
        data: data);

    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 && res?.data != null ) {
      try {
        return StaffMealCardResult.fromJson(res!.data);
      } on FormatException catch (e) {
        // Handle parsing error gracefully
        print('Error parsing StaffMealCardResult: $e');
        return null;
      } catch (e) {
        // Handle other unexpected errors
        print('Unexpected error updating staff meal plan: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  // Future<MealSummaryResults?> fetchDayMealSummary() async {
  //   final res = await ApiClient.call('Meal/summary', ApiMethod.POST);

  //   ///${userId}
  //   if (res?.data == null) {
  //     return null;
  //   }

  //   return MealSummaryResults.fromJson(res!.data);
  // }

  Future<MealSummaryResults?> fetchDayMealSummary(DateTime date) async {
    // Format the provided date to the required ISO 8601 format
    String formattedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(date);

    // Create the request body
    Map<String, dynamic> requestBody = {
      "date": formattedDate,
    };

    // Call the API with the request body
    final res =
        await ApiClient.call('Meal/summary', ApiMethod.POST, data: requestBody);

    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 &&
        res?.data != null &&
        res?.data['success'] == true) {
      return MealSummaryResults.fromJson(res!.data);
    } else {
      return null;
    }
  }

  Future<HistoryCardResult?> fetchSupplierHistory() async {
    final res = await ApiClient.call("Meal/daily_summary", ApiMethod.GET);
    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 &&
        res?.data != null &&
        res?.data['success'] == true) {
      return HistoryCardResult.fromJson(res!.data);
    } else {
      return null;
    }
  }

  Future<StaffHistoryCardResult?> fetchStaffHistory() async {
    final res = await ApiClient.call("Meal/user/daily_summary", ApiMethod.GET);
    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 &&
        res?.data != null &&
        res?.data['success'] == true) {
      return StaffHistoryCardResult.fromJson(res!.data);
    } else {
      return null;
    }
  }

  Future<ImageResult?> fetchMealImage() async {
    final res = await ApiClient.call("Meal/all_meals", ApiMethod.GET, errorToast: false);

    if (res?.data == null) {
      return null;
    } else if (res?.statusCode == 200 &&
        res?.data != null &&
        res?.data['success'] == true) {
      return ImageResult.fromJson(res!.data);
    } else {
      return null;
    }
  }
}
