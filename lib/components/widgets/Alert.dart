// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  final List<Widget>? actions;
  final String title;
  final Widget? content;
  final bool notificaiton;

  const Alert(
      {Key? key,
      this.actions,
      required this.title,
      this.content,
      this.notificaiton= false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    final _text = widget.title == null ? "" : widget.title;
    Widget title = widget.notificaiton
        ? Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF1c1c1a),
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.055,
                      fontFamily: "Centuary Gothic"),
                ),
              ),
              Icon(
                Icons.notifications_active,
                color: Color(0xFF1c1c1a),
              )
            ],
          )
        : Text(
            _text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF1c1c1a),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.055,
                fontFamily: "Centuary Gothic"),
          );

    return Container(
      child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          backgroundColor: Color(0xFFC6C6C4),
          title: title,
          content: widget.content,
          actions: widget.actions),
    );
  }
}
