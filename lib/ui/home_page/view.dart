import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(HomeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: (){
          dispatch(HomeActionCreator.onRefresh());
        },
        onLoading: (){
          dispatch(HomeActionCreator.onLoadMore());
        },
        controller: new RefreshController(initialRefresh: true),
        child: ListView.builder(
          itemBuilder: (c, i) => Card(child: Center(child: Text(state.items[i]),),),
          itemCount: state.items.length,
          itemExtent: 100,
          ),
      ),
  );
}
