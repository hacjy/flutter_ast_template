import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> confirm(BuildContext context, String title, String content){
  final dialog = CupertinoAlertDialog(
    title: Text(title),
    content:Text(content),
    actions:<Widget>[
      CupertinoDialogAction(
        child: Text('取消'),
        onPressed: (){
          Navigator.of(context).pop('cancel');
        },
      ),

      CupertinoDialogAction(
        child: Text('确认'),
        onPressed: (){
          Navigator.of(context).pop('ok');
        },
      ),
    ],
  );
  return showDialog(
      context: context,
      builder: (ctx) {
        return dialog;
      });
}