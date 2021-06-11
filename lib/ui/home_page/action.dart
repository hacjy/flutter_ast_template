import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum HomeAction { Refresh, LoadMore, Update }

class HomeActionCreator {
  static Action onRefresh() {
    return const Action(HomeAction.Refresh);
  }

  static Action onLoadMore() {
    return const Action(HomeAction.LoadMore);
  }

  static Action onUpdate() {
    return const Action(HomeAction.Update);
  }
}
