import 'package:flutter/material.dart';

/// 保持状态的包裹类 主要是fish_redux需要这样做

/// 正常的话 只要state with AutomaticKeepAliveClientMixin
/// @override bool get wantKeepAlive => true; 就可以
class KeepAliveWidget extends StatefulWidget {
  final Widget child;
  const KeepAliveWidget(this.child);
  @override
  State<StatefulWidget> createState() => _KeepAliveState();
}
class _KeepAliveState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
Widget keepAliveWrapper(Widget child) => KeepAliveWidget(child);