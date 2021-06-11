import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'popup.dart';
void showNationPopup(BuildContext context) async {
  final data = await rootBundle.loadString('packages/toolbox/assets/data/nation.json');
  List nations = jsonDecode(data);
  final picker = CupertinoPicker(
    itemExtent: 45,
    onSelectedItemChanged: (index) {
      print(nations[index]);
    },
    children: nations.map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          e['name'],
        ),
      );
    }).toList(),
  );
  showPopupWithButtons(context, picker);
}