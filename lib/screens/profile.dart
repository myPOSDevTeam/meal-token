import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/models/common.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Icon(
                Icons.arrow_back,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
        title: Text('Your Profile'),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64.decode(COMMON.userImageByte);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              COMMON.NAME,
              style: CustomTextStyles.titleMedium4,
            ),
            accountEmail: Text(
              COMMON.USERID,
              style: CustomTextStyles.titleMedium4,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: bytes.isNotEmpty
                  ? MemoryImage(bytes)
                  : AssetImage('assets/images/image_not_found.png')
                      as ImageProvider, // Replace with your asset path
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: CustomTextStyles.titleMedium5,
            ),
            onTap: () {
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, AppRoutes.screenone);
            },
          ),
          ListTile(
            title: Text(
              'History',
              style: CustomTextStyles.titleMedium5,
            ),
            onTap: () {
              // // Navigate to settings screen
              Navigator.pushNamed(context, AppRoutes.historyScreen);
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Do You Want To Signout?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              await storage.deleteAll();
                              // COMMON.timer?.cancel();
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.loginscreen);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.black),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
