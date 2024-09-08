import 'package:flutter/material.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/home/slider_widget.dart';

class PopularUi extends StatelessWidget {
  const PopularUi({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            SliderWidget(
              movies: popularMovies,
              imageUrlBuilder: (index) =>
              "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}",
              titleBuilder: (index) => popularMovies[index].title ?? 'No Title',
              subtitleBuilder: (index) =>
              popularMovies[index].releaseDate ?? 'No Release Date',
              displayBookmark: false,
              height: 270,
              top: 0,
              left: 0,
              right: 0,
              showPlayIcon: true,
            ),
            SliderWidget(
              movies: popularMovies,
              imageUrlBuilder: (index) =>
              "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}",
              displayBookmark: true,
              height: 165,
              top: 95,
              left: 30,
              right: 220,
              showPlayIcon: false,
              borderRadius: 10,
            ),
          ],
        );
      },
    );
  }
}