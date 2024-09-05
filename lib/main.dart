import 'package:flutter/material.dart';
import 'package:movies_app_c11/Browse.dart';
import 'package:movies_app_c11/HomePage.dart';
import 'package:movies_app_c11/WatchList.dart';


void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   initialRoute: HomePage.routeName,
   routes: {
    HomePage.routeName: (context) => HomePage(),

    WatchKListScreen.routeName:(context) => WatchKListScreen(),
    Browse.routeName:(context) => Browse(),

   },
   debugShowCheckedModeBanner: false,

  );
 }
}
