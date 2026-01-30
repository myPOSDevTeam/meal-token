import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:jkh_mealtoken/components/theme/custom_text_style.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/supplier_mealcard_results.dart';
import 'package:jkh_mealtoken/screens/mealsgrid_screen.dart';
import 'package:jkh_mealtoken/screens/supplier_day_summary_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String? _barcode;
  late bool visible;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        visible = info.visibleFraction > 0;
      },
      key: Key('visible-detector-key'),
      child: BarcodeKeyboardListener(
        bufferDuration: Duration(milliseconds: 200),
        onBarcodeScanned: (barcode) {
          if (!visible) return;
          print(barcode);
          setState(() {
            _barcode = barcode;
          });
          NavigateToMealGridScreen(barcode: _barcode);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _barcode == null ? 'SCAN BARCODE' : 'BARCODE: $_barcode',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () {
                    NavigateToMealGridScreen(barcode: _barcode);
                  },
                  child: Center(child: Text('Second screen'))),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> NavigateToMealGridScreen({String? barcode}) async {
    if (barcode!.startsWith("userId")) {
      final String userId = barcode.split(":")[1];
      MealController mealController = MealController();
      MealCardResult? mealCardResult =
          await mealController.fetchMealPlans(userId.trim());

      if (mealCardResult?.success == true && mealCardResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealGridScreen(
              userId: userId,
              mealCardResult: mealCardResult,
            ),
          ),
        );

        //update

        // Show toast message for successful scanning
        // _showToast("Scanning Successfully");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No meals allocated"),
              content: Text("Please try again.",
                  style: CustomTextStyles.titleMedium2),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(child: Text("OK")),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error message for invalid format
      // _showToast("Invalid Qr Code");

      // Show dialog box for invalid QR code
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid QR Code"),
            content: Text("The scanned QR code is invalid. Please try again.",
                style: CustomTextStyles.titleMedium2),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(child: Text("OK")),
              ),
            ],
          );
        },
      );
    }
  }
}
