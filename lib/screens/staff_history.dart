import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/staff_history_results.dart';

class StaffMealHistory extends StatefulWidget {
  const StaffMealHistory({super.key});

  @override
  State<StaffMealHistory> createState() => _StaffMealHistoryState();
}

class _StaffMealHistoryState extends State<StaffMealHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
        title: Text(
          'Your Meal History',
          style: CustomTextStyles.appbartitle,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.screenone,
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.height * 0.02,
            )),
      ),
      body: FutureBuilder<StaffHistoryCardResult?>(
        future: MealController().fetchStaffHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  MealController().fetchStaffMealPlans();
                });
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              label: Text(
                'Refresh',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            final staffHistoryCardResult = snapshot.data;
            if (staffHistoryCardResult != null &&
                staffHistoryCardResult.success == true) {
              return ListView.builder(
                  itemCount: staffHistoryCardResult.staffhistoryItems!.length,
                  itemBuilder: (context, index) {
                    final item =
                        staffHistoryCardResult.staffhistoryItems![index];
                    return CustomHistoryListTile(
                        title: item.providedDate ?? "",
                        subtitle1: item.mealName ?? "",
                        timeperiod: item.mealDescription ?? "");
                  });
            } else {
              return Text('No meal history Available');
              // return ElevatedButton.icon(
              //   onPressed: () {
              //     setState(() {
              //       MealController().fetchStaffMealPlans();
              //     });
              //   },
              //   icon: Icon(
              //     Icons.refresh,
              //     color: Colors.black,
              //   ),
              //   label: Text(
              //     'Refresh',
              //     style: TextStyle(color: Colors.black),
              //   ),
              // );
            }
          }
        },
      ),
    );
  }
}

class CustomHistoryListTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String timeperiod;

  const CustomHistoryListTile({
    Key? key,
    required this.title,
    required this.subtitle1,
    required this.timeperiod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: ListTile(
        title: Text(title, style: CustomTextStyles.titleMedium7),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  subtitle1,
                  style: CustomTextStyles.titleMedium8,
                ),
              ],
            ),
            Text(
              timeperiod,
              style: CustomTextStyles.titleMedium5,
            ),
          ],
        ),
        onTap: () {
          // Do something when the tile is tapped
        },
      ),
    );
  }
}
