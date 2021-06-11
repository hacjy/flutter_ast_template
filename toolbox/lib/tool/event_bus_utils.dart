import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';

/// EventBus的工具类
/// 参考自：https://blog.csdn.net/IT_Boy_/article/details/105295764?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase
class EventBusUtils {
  // 单列模式
  static EventBus _eventBus;

  static EventBus shared() {
    if (_eventBus == null) {
      _eventBus = EventBus(); // 创建事件总线
    }
    return _eventBus;
  }

  /// 订阅者
  static Map<Object, List<StreamSubscription>> subscriptions = {};

  /// 添加监听事件
  /// [T] 事件泛型 必须要传
  /// [onData] 接受到事件
  /// [autoManaged] 自动管理实例，off 取消
  static StreamSubscription on<T extends Object>(void onData(T event),
      {Function onError,
        void onDone(),
        bool cancelOnError,
        bool autoManaged = true}) {
    StreamSubscription subscription = shared()?.on<T>()?.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    if (autoManaged == true) {
      if (subscriptions == null) subscriptions = {};
      //这个写法会导致同一个Event只能注册一个，导致只有最后一个注册的地方可以收到通知，所以注释掉
//      List<StreamSubscription> subs = subscriptions[T.runtimeType] ?? [];
      List<StreamSubscription> subs = [];
      subs.add(subscription);
      subscriptions[T.hashCode] = subs;
    }
    return subscription;
  }

  /// 移除监听者
  /// [T] 事件泛型 必须要传
  /// [subscription] 指定
  static void off<T extends Object>({StreamSubscription subscription}) {
    if (subscriptions == null) subscriptions = {};
    if (subscription != null) {
      // 移除传入的
//      List<StreamSubscription> subs = subscriptions[T.runtimeType] ?? [];
      List<StreamSubscription> subs = subscriptions[T.hashCode] ?? [];
      subs.remove(subscription);
//      subscriptions[T.runtimeType] = subs;
      subscriptions[T.hashCode] = subs;
    } else {
      // 移除全部
//      subscriptions[T.runtimeType] = null;
      subscriptions[T.hashCode] = null;
    }
  }

  /// 发送事件
  static void fire(event) {
    shared()?.fire(event);
  }
}

/// EventBus的工具类
/// 有状态组件
mixin EventBusMixin<T extends StatefulWidget> on State<T> {
  /// 需要定义成全局的,共用一个是实例
  EventBus mEventBus = EventBusUtils.shared();

  /// 订阅者
  List<StreamSubscription> mEventBusSubscriptions = [];

  /// 统一在这里添加监听者
  @protected
  void mAddEventBusListeners();

  /// 添加监听事件
  void mAddEventBusListener<T>(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    mEventBusSubscriptions?.add(mEventBus?.on<T>()?.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError));
  }

  /// 发送事件
  void mEventBusFire(event) {
    mEventBus?.fire(event);
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    debugPrint('dispose:EventBusMixin');
    if (mEventBusSubscriptions != null)
      for (StreamSubscription subscription in mEventBusSubscriptions) {
        subscription.cancel();
      }
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    debugPrint('initState:EventBusMixin');
    mAddEventBusListeners();
  }
}