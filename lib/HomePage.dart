import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home'; // Ensure this matches the string in the routes map.

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('GeeksForGeeks'),
      ),
    );
  }
}
