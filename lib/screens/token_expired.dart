import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TokenExpired extends StatefulWidget {
  const TokenExpired({super.key});

  @override
  State<TokenExpired> createState() => _TokenExpiredState();
}

class _TokenExpiredState extends State<TokenExpired> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Token expired'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                String? token = await storage.read(key: 'accessToken');
                await decodeToken(token ?? '');
                showDialog11(token ?? '');
              },
              child: Text('Generate'))
        ],
      ),
    );
  }

  void showDialog11(String token) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("${decodeToken(token).toString()}"),
          );
        });
  }

 bool decodeToken(String token) {
    final jwt = JWT.decode(token);
    var body = jwt.payload;
    int exp = body['exp'];

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

    return DateTime.now().isAfter(dateTime);


  }
}
