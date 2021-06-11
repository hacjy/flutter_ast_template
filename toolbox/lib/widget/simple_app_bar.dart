import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toolbox/ui/pixel.dart';

const defaultHeight = 40.0;
const subTitleHeight = 30.0;
class SimpleAppBar extends StatefulWidget implements PreferredSizeWidget {

  SimpleAppBar({
    this.title,
    this.titleStyle,
    this.titleClick,
    this.titleRightChild,
    this.subTitle,
    this.child,
    this.bottom,
    this.hint = '',
    this.back = true,
    this.backClick,
    this.backChild,
    this.center = false,
    this.appBarHeight = defaultHeight
  }):preferredSize = Size.fromHeight(appBarHeight + (subTitle == null ? 0.0 : subTitleHeight) + (bottom?.preferredSize?.height ?? 0.0));

  @override
  State<StatefulWidget> createState() {
    return _SimpleAppBarState();
  }

  final double appBarHeight;
  final PreferredSizeWidget bottom;
  final String subTitle;
   String title = '';
   Widget titleRightChild;
   Widget child;
   Widget backChild;
   bool back;
   Function backClick;
   bool center;
   TextStyle titleStyle;
   Function titleClick;
  final TextStyle subTitleStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600
  );

  final String hint;
  final TextStyle hintStyle = TextStyle(
      fontSize: 14,
      color: Color(0xFF767676)
  );

  @override
  final Size preferredSize;

}

class _SimpleAppBarState extends State<SimpleAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      constraints: BoxConstraints.expand(height: widget.appBarHeight),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Visibility(
            visible:widget.back,
            child: Positioned(
                left: 0,
                child: widget.backChild==null?
                IconButton(
                  onPressed: () {
                    if(widget.backClick == null) {
                      Navigator.of(context).pop();
                    }else{
                      widget.backClick();
                    }
                  },
                  iconSize: FixPixel.px(16),
                  icon: Icon(Icons.arrow_back_ios),
                ):FlatButton(
                  child:widget.backChild,
                  onPressed: () {
                    if(widget.backClick == null) {
                      Navigator.of(context).pop();
                    }else{
                      widget.backClick();
                    }
                  },
                )
            ),
          ),

          Positioned(
            left: widget.back?FixPixel.px(45):FixPixel.px(20),
            right: widget.back?FixPixel.px(45):FixPixel.px(20),
            child:  
            GestureDetector(
              onTap: (){
                if(widget.titleClick != null){
                  widget.titleClick();
                }
              },
              child:Container(
                alignment: widget.center?Alignment.center:Alignment.centerLeft,
                child:Text(widget.title==null?'':widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:widget.titleStyle??TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: widget.back?FontWeight.w600:FontWeight.w500
                    )),)
            )
          ),
          Positioned(
            right: FixPixel.px(15),
            child: widget.titleRightChild==null?Container():widget.titleRightChild,
          )
        ],
      ),
    );
    List<Widget> appBarList = [];
    appBarList.add(appBar);
    if (widget.bottom != null) {
      appBarList.add(widget.bottom);
    }
    if (widget.subTitle != null) {
      appBarList.add(
          Container(
            constraints: BoxConstraints.expand(height: 30),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Text(widget.subTitle,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: Text(widget.hint,
                    style: widget.hintStyle,
                  ),
                ),
                Positioned(
                  top: -6,
                  bottom: 0,
                  right: 10,
                  child: widget.child==null?Container():widget.child,
                  ),
              ],
            ),
          )
      );
    }

    return SafeArea(
      top: true,
      child: Column(
        children: appBarList,
      ),
    );
  }

}