
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_c11/Browse.dart';
import 'package:movies_app_c11/HomePage.dart';
import 'package:movies_app_c11/WatchList.dart';
import 'package:movies_app_c11/firebase_options.dart';
 import'package:movies_app_c11/HomeScreenDetails.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
 );
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
    MovieDetailsScreen.routeName:(context) => MovieDetailsScreen(),

   },
   debugShowCheckedModeBanner: false,

  );
 }
}
