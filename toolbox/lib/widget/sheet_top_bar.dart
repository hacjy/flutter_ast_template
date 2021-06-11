import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toolbox/ui/pixel.dart';

class SheetTopBar extends StatefulWidget {
  SheetTopBar({
    this.title = '',
    this.back = true,
    this.showAction = false,
    this.titleClick,
    this.bgColor,
    this.actionText = '',
    this.actionClick,
});

  @override
  State<StatefulWidget> createState() {
    return _SheetTopBarState();
  }

  final String title;
  final bool back;
  //针对图标
  final bool showAction;
  final Function titleClick;
  Color bgColor =  Color(0xFFF8F8F8);
  final String actionText;
  final Function actionClick;
}

class _SheetTopBarState extends State<SheetTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor==null?Color(0xFFF8F8F8):widget.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      alignment: Alignment.topCenter,
      constraints: BoxConstraints.expand(height: FixPixel.px(68)),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: FixPixel.px(18),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.titleClick,
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: FixPixel.px(18),
                      fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: widget.showAction?FixPixel.px(8):FixPixel.px(18),
            right: widget.showAction?FixPixel.px(8):FixPixel.px(18),
            child: widget.showAction?
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(FixPixel.px(8)),
                  child: Icon(Icons.close, color:Colors.black,size: FixPixel.px(20)),
                ),
              ),
            )
            :Material(
              child: GestureDetector(
                onTap: widget.actionClick,
                child: Text(
                  widget.actionText,
                  textAlign:TextAlign.right,
                  style: TextStyle(
                    fontSize: FixPixel.px(16),
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ),
          ),
          !widget.back ? Container() : Positioned(
              top: FixPixel.px(8),
              left: FixPixel.px(2),
              child: Material(
                color: Color(0xFFF8F8F8),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(FixPixel.px(14)),
                    child: Icon(Icons.arrow_back_ios, size: FixPixel.px(16)),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

}