import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_fast_template/route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toolbox/log/log.dart';
import 'package:toolbox/res/colors.dart';

Widget buildApp(){
  var routes = buildRoutes();

  return
      MaterialApp(
    builder: (context, child){
      return Material(
          child: FlutterEasyLoading(
                child:MediaQuery(
                    child: Container(child: child),
                    data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0)
                ),
      ),);
    },
    theme: ThemeData(
      primarySwatch: AppColors.primaryColors,
      backgroundColor: AppColors.pageBackgroundColor,
      scaffoldBackgroundColor: AppColors.pageBackgroundColor,
      dividerColor: AppColors.dividerColor,
      cursorColor: AppColors.primaryColor,
      appBarTheme: AppBarTheme(
        color: AppColors.pageBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(

        )
      ),
    ),
    home: routes.buildPage('/', null),
    localizationsDelegates: [
      RefreshLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('zh','CH'),
      const Locale('en','US'),
    ],
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        Log.info('route >>>${settings.name}<<<');
        return routes.buildPage(settings.name, settings.arguments);
      });
    },
  );
}