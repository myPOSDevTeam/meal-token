import 'dart:async';

import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/meal_summary_results.dart';
import 'package:rxdart/rxdart.dart';

class MealBloc {
  var _mealsummary = BehaviorSubject<MealSummaryResults?>();

  Stream<MealSummaryResults?> get mealSummarySnapshot => _mealsummary.stream;

  MealSummaryResults? get mealSummary => _mealsummary.valueOrNull;

  Future<void> addMealSummaryResult(DateTime selectedDate) async {
    var res = await MealController().fetchDayMealSummary(selectedDate);
    _mealsummary.sink.add(res);
  }
}

final mealBloc = MealBloc();
