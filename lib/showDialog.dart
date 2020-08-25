import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String message1, String message2) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(message1),
      content: Text(message2, style: TextStyle(color: Colors.black)),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Okay',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
