import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/theme/custom_text_style.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/supplier_history_results.dart';
import 'package:jkh_mealtoken/routes/app_routes.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SupplierHistory extends StatefulWidget {
  const SupplierHistory({super.key});

  @override
  State<SupplierHistory> createState() => _SupplierHistoryState();
}

class _SupplierHistoryState extends State<SupplierHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromARGB(255, 160, 206, 243).withOpacity(0.1),
        backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
        appBar: AppBar(
            title: Text('Daily Meal Summaries'),
            leading: IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return BoxChart();
                  // }));
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.supplerScreen,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: MediaQuery.of(context).size.height * 0.02,
                ))),
        body: FutureBuilder<HistoryCardResult?>(
          future: MealController().fetchSupplierHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.historycardItems != null &&
                snapshot.data!.historycardItems!.isNotEmpty) {
              final dailySummaries = snapshot.data!.historycardItems!;
              return ListView.builder(
                itemCount: dailySummaries.length,
                itemBuilder: (context, index) {
                  final summary = dailySummaries[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        summary['date'],
                        style: CustomTextStyles.titleMedium3,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          summary['value']?.length ?? 0,
                          (index) {
                            HistoryCardItem value = summary['value'][index];

                            double percentage =
                                (value.mealAllocatedCount ?? 1) != 0
                                    ? (((value.mealProvidedCount ?? 0) /
                                        (value.mealAllocatedCount ?? 1)))
                                    : 0;

                            if (percentage.isNaN) {
                              percentage = 0;
                            } else if (percentage > 1) {
                              percentage = 1;
                            }

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${value.mealName}',
                                              style:
                                                  CustomTextStyles.titleMedium4,
                                            ),
                                            LinearPercentIndicator(
                                              width: 140.0,
                                              lineHeight: 14.0,
                                              percent: percentage,
                                              center: Text(
                                                "${roundToTwoDecimalPlaces(percentage * 100)}%",
                                                style: new TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                              // trailing: Icon(Icons.mood),
                                              linearStrokeCap:
                                                  LinearStrokeCap.roundAll,
                                              // backgroundColor: Colors.grey,
                                              progressColor: Colors.green,
                                            ),
                                            // Text(
                                            //   'Issued: ${percentage.toStringAsFixed(2)}%',
                                            //   style:
                                            //       CustomTextStyles.titleMedium6,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Allocated: ${(value.mealAllocatedCount ?? 0).toInt()}',
                                          style: CustomTextStyles.titleMedium5
                                              .copyWith(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          'Provided: ${(value.mealProvidedCount ?? 0).toInt()}',
                                          style: CustomTextStyles.titleMedium5
                                              .copyWith(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: 20),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: SizedBox(
                                  //     width: 80,
                                  //     height: 80,
                                  //     child: PieChart(
                                  //       PieChartData(
                                  //         sections: [
                                  //           PieChartSectionData(
                                  //             value:
                                  //                 (value.mealProvidedCount ?? 0)
                                  //                     .toInt()
                                  //                     .toDouble(),
                                  //            // color: providedColor,
                                  //             radius: 30,
                                  //             titleStyle: TextStyle(
                                  //                 color: Colors.white),
                                  //           ),
                                  //           PieChartSectionData(
                                  //             value:
                                  //                 (value.mealAllocatedCount ??
                                  //                         0)
                                  //                     .toInt()
                                  //                     .toDouble(),
                                  //             //color: allocatedColor,
                                  //             radius: 30,
                                  //             titleStyle: TextStyle(
                                  //                 color: Colors.white),
                                  //           ),
                                  //         ],
                                  //         sectionsSpace: 0,
                                  //         centerSpaceRadius: 0,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                  // return Container(
                  //   // height: MediaQuery.of(context).size.height * 0.8,
                  //   child: Card(
                  //     margin: EdgeInsets.all(8),
                  //     child: Column(
                  //       children: [
                  //         ListTile(
                  //           title: Text(
                  //             summary['date'],
                  //             style: CustomTextStyles.titleMedium3,
                  //           ),
                  //           subtitle: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: List.generate(
                  //               summary['value']?.length ?? 0,
                  //               (index) {
                  //                 HistoryCardItem value =
                  //                     summary['value'][index];

                  //                 double percentage =
                  //                     (value.mealAllocatedCount ?? 1) != 0
                  //                         ? ((value.mealProvidedCount ?? 0) /
                  //                                 (value.mealAllocatedCount ??
                  //                                     1)) *
                  //                             100
                  //                         : 0;

                  //                 if (percentage.isNaN) {
                  //                   percentage = 0;
                  //                 }

                  //                 return Padding(
                  //                   padding: EdgeInsets.symmetric(
                  //                       vertical: 4, horizontal: 8),
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Text(
                  //                             '${value.mealName}',
                  //                             style:
                  //                                 CustomTextStyles.titleMedium4,
                  //                           ),
                  //                           Text(
                  //                             'Issued: ${percentage.toStringAsFixed(2)}%',
                  //                             style:
                  //                                 CustomTextStyles.titleMedium6,
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       SizedBox(height: 4),
                  //                       Text(
                  //                         'Allocated: ${value.mealAllocatedCount ?? 0}',
                  //                         style: CustomTextStyles.titleMedium5,
                  //                       ),
                  //                       Text(
                  //                         'Provided: ${value.mealProvidedCount ?? 0}',
                  //                         style: CustomTextStyles.titleMedium5,
                  //                       ),
                  //                       SizedBox(height: 10),
                  //                     ],
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //         // SizedBox(
                  //         //   height: 150, // Adjust height as needed
                  //         //   child: PieChart(
                  //         //     PieChartData(
                  //         //       sections: summary['value']
                  //         //           .map<PieChartSectionData>((value) {
                  //         //         HistoryCardItem item =
                  //         //             value as HistoryCardItem;
                  //         //         return PieChartSectionData(
                  //         //           value: item.mealProvidedCount!.toDouble(),
                  //         //           title: '${item.mealName}',
                  //         //           color: Color.fromRGBO(
                  //         //               Random().nextInt(256),
                  //         //               Random().nextInt(256),
                  //         //               Random().nextInt(256),
                  //         //               1),
                  //         //           radius: 60,
                  //         //           titleStyle: TextStyle(
                  //         //             fontSize: 16,
                  //         //             fontWeight: FontWeight.bold,
                  //         //             color: Colors.white,
                  //         //           ),
                  //         //         );
                  //         //       }).toList(),
                  //         //       borderData: FlBorderData(show: false),
                  //         //       sectionsSpace: 0,
                  //         //       centerSpaceRadius: 40,
                  //         //     ),
                  //         //   ),
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        )
        // FutureBuilder<List<DailySummary>>(
        //   future: summaries,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       final dailySummaries = snapshot.data!;
        //       return ListView.builder(
        //         itemCount: dailySummaries.length,
        //         itemBuilder: (context, index) {
        //           final summary = dailySummaries[index];
        //           return ListTile(
        //             title: Text(DateFormat('y-MM-d').format(summary.date)),
        //             subtitle: Text(
        //               'Allocated: ${summary.totalAllocatedCount}, Provided: ${summary.totalProvidedCount}\n'
        //               'Staff: ${summary.totalStaffCount}, Temporary: ${summary.totalTemporyCount}',
        //             ),
        //           );
        //         },
        //       );
        //     } else if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));
        //     }
        //     return Center(child: CircularProgressIndicator());
        //   },
        // ),
        );
  }
}

double roundToTwoDecimalPlaces(double value) {
  return double.parse((value).toStringAsFixed(2));
}
