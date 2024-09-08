import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/browes_screen/Browse.dart';
import 'package:movies_app_c11/home/HomePage.dart';
import 'package:movies_app_c11/search_screen/search_provider.dart';
import 'package:movies_app_c11/search_screen/search_tab.dart';
import 'package:movies_app_c11/watch_list/WatchList.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Appcolors.primary,
      child: Row(
        children: [
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, HomePage.routeName);
            },
            icon: Icon(Icons.home_sharp, color: Appcolors.whiteColor),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchTab(
                  searchProvider:
                  Provider.of<SearchProvider>(context, listen: false),
                ),
              );
            },
            icon: Icon(Icons.search, color: Appcolors.whiteColor),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Browse.routeName);
            },
            icon: Icon(Icons.movie_creation, color: Appcolors.whiteColor),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, WatchListScreen.routeName);
            },
            icon: Icon(Icons.collections_bookmark, color: Appcolors.whiteColor),
          ),
          Spacer(),
        ],
      ),
    );
  }
}