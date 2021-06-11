import 'package:flutter/cupertino.dart';
import 'popup.dart';
typedef GetValue = String Function(dynamic value);
void showSimpleListPopup(BuildContext context, List data, ValueChanged onChanged,{GetValue getValue}) async {
  final picker = CupertinoPicker(
    itemExtent: 45,
    onSelectedItemChanged: onChanged,
    children: data.map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          getValue == null ? e : getValue(e),
        ),
      );
    }).toList(),
  );
  showPopupWithButtons(context, picker);
}