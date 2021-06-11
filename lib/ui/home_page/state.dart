import 'package:fish_redux/fish_redux.dart';

class HomeState implements Cloneable<HomeState> {
  List items = [];

  @override
  HomeState clone() {
    return HomeState()
    ..items = items;
  }
}

HomeState initState(Map<String, dynamic> args) {
  return HomeState();
}
