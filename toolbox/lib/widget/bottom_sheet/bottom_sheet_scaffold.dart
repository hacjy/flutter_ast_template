import 'package:flutter/material.dart';

import '../sheet_top_bar.dart';

class BottomSheetScaffold extends StatefulWidget {

  const BottomSheetScaffold(
      {
        Key key,
        this.body,
        this.controller,
        this.title,
        this.back = true,
        this.action
      }
      ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetScaffoldState();
  }

  final ScrollController controller;
  final Widget body;
  final String title;
  final bool back;
  final String action;
}

class _BottomSheetScaffoldState extends State<BottomSheetScaffold> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [ //阴影
            BoxShadow(
                color:Colors.black26,
                offset: Offset(2.0,2.0),
                blurRadius: 6
            )
          ]
      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Container(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              SheetTopBar(
                title: widget.title,
                back: widget.back,
                titleClick: (){
                },
              ),
              widget.body
            ],
          ),
        ),
      ),
    );
  }

}