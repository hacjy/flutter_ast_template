import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<HomeState> buildEffect() {
  return combineEffects(<Object, Effect<HomeState>>{
    HomeAction.Refresh: _onRefresh,
    HomeAction.LoadMore: _onLoadMore,
  });
}

void _onRefresh(Action action, Context<HomeState> ctx) {
  Future.delayed(Duration(milliseconds: 300),(){
    ctx.state.items = ["1","2","3","4","5"];
    ctx.dispatch(HomeActionCreator.onUpdate());
  });
}

void _onLoadMore(Action action, Context<HomeState> ctx) {
  Future.delayed(Duration(milliseconds: 300),(){
    ctx.state.items = ["11","12","13","14","15"];
    ctx.dispatch(HomeActionCreator.onUpdate());
  });
}
