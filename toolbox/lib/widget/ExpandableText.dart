import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum Direction{
  horizontal,
  vertical
}

///展开收起的文本控件
class ExpandableText extends StatefulWidget {
   String text;
   int maxLines;
   TextStyle style;
   TextStyle linkStyle;
   bool expand;
   String expandText;
   String collaspText;
   Direction direction;
   _ExpandableTextState state;

   ExpandableText(
      {Key key,
        this.text,
        this.maxLines,
        this.style,
        this.linkStyle,
        this.expand,
        this.expandText,
        this.collaspText,
        this.direction,
      })
      : super(key: key);

  void toggle(){
    if(state != null){
      state.refreshUI();
    }
  }
  
  @override
  State<StatefulWidget> createState() {
    return state = _ExpandableTextState(text, maxLines, style, expand,linkStyle,
        expandText,collaspText,direction);
  }
  
  
}

class _ExpandableTextState extends State<ExpandableText> {
  final String text;
  final int maxLines;
  final TextStyle style;
  bool expand;
  final TextStyle linkStyle;
  String expandText;
  String collaspText;
  Direction direction;

  _ExpandableTextState(this.text, this.maxLines, this.style, this.expand,
      this.linkStyle,this.expandText,this.collaspText,this.direction) {
    if (expand == null) {
      expand = false;
    }
    if(expandText == null || expandText == ''){
      expandText = '展开';
    }
    if(collaspText == null || collaspText == ''){
      collaspText = '收起';
    }
    if(direction == null){
      direction = Direction.horizontal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      direction==Direction.horizontal?createRowView():createColumnView();
  }

  Widget createColumnView(){
    //LayoutBuilder 延迟加载 TextPainter计算文本行数
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: text ?? '', style: style);
      final tp = TextPainter(
          text: span, maxLines: maxLines, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);
      if (tp.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            expand
                ? Text(text ?? '', style: style)
                : Text(text ?? '',
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: style),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                refreshUI();
              },
              child: Container(
                padding: EdgeInsets.only(top: 2),
                child: Text(expand ? collaspText : expandText,
                    style:linkStyle??TextStyle(
                        fontSize: style != null ? style.fontSize : null,
                        color: Colors.black)),
              ),
            ),
          ],
        );
      } else {
        return Text(text ?? '', style: style);
      }
    });
  }

  Widget createRowView(){
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: text ?? '', style: style);
      final tp = TextPainter(
          text: span, maxLines: maxLines, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);

      //计算文本除去展开收起的位置
      final linkWidth = tp.width;
      final textSize = tp.size;
      //获取占满这个区域的String的最后一个字符的index(第几个就返回几)
      final position = tp.getPositionForOffset(Offset(
        textSize.width - linkWidth,
        textSize.height,
      ));
      final endOffset = tp.getOffsetBefore(position.offset);

      TextSpan textSpan;
      if (tp.didExceedMaxLines) {
          textSpan = TextSpan(
            style: style,
            text: expand? widget.text : widget.text.substring(0, endOffset-2)+"...",
            children: <TextSpan>[
          TextSpan(
              text: expand ? '' : '',
              style: style,
          ),
              TextSpan(
                  text: expand ? collaspText : expandText,
                  style: linkStyle??TextStyle(
                      fontSize: style != null ? style.fontSize : null,
                      color: Colors.black),
                  recognizer:TapGestureRecognizer()..onTap=(){
                    refreshUI();
                  }
              ),
            ],
          );
        } else {
          textSpan = span;
        }

        return
          RichText(
            text: textSpan,
            softWrap: true,
            overflow: TextOverflow.clip,
        );
    });
  }
  
  void refreshUI(){
    setState(() {
      expand = !expand;
    });
  }
}
