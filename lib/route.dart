import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_fast_template/ui/home_page/page.dart';

AbstractRoutes buildRoutes(){

  var pages = <String, Page<Object, dynamic>>{
        '/': HomePage(),
  };


  return PageRoutes(
    pages: pages
  );
}