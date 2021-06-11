import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<HomeState>>{
      HomeAction.Update: _onUpdate,
    },
  );
}

HomeState _onUpdate(HomeState state, Action action) {
  final HomeState newState = state.clone();
  return newState;
}
