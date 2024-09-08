import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/home/new_reals.dart';
import 'package:movies_app_c11/home/popular_UI.dart';
import 'package:movies_app_c11/home/recommended.dart';
import 'package:movies_app_c11/nav_bar.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primary,
      body: FutureBuilder(
        future: ApiManager.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }

          var popularMovies = snapshot.data?.results ?? [];

          return Stack(
            children: [
              // Use Positioned to control the height of PopularUi
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.4,
                child: PopularUi(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.3558, // Start from below PopularUi
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Appcolors.secondary,
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: NewReals(),
                    ),
                    SizedBox(height: 15),
                    Recommended(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}