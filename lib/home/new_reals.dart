import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/firebase_functions.dart';
import 'package:movies_app_c11/watch_list/whatch_list_model.dart';

import '../movie _details/movie_details_screen.dart';

class NewReals extends StatelessWidget {
  const NewReals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('New Release', style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 5),
        FutureBuilder(
          future: ApiManager.getUpComingMovies(),
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

            var upcomingMovies = snapshot.data?.results ?? [];

            return Container(
              height: 130,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingMovies.length,
                itemBuilder: (context, index) {
                  String imageUrl =
                      "https://image.tmdb.org/t/p/w500${upcomingMovies[index].posterPath ?? ''}";
                  int movieId = upcomingMovies[index].id ?? 0;

                  return Container(
                    width: 90,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MovieDetailsScreen.routeName,
                          arguments: upcomingMovies[index].id,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          children: [
                            Image.network(
                              imageUrl,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Appcolors.whiteColor,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: GestureDetector(
                                onTap: () async {
                                  var movie = upcomingMovies[index];
                                  await FirebaseFunctions.addMovie(
                                      MovieModelWatchList(
                                        title: movie.title ?? '',
                                        imageUrl:
                                        "https://image.tmdb.org/t/p/w500${movie.posterPath ?? ''}",
                                        releaseDate: movie.releaseDate ?? '',
                                        id: '', // ID will be set by Firestore
                                      ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                          'Movie added to watchlist',
                                          style:
                                          Theme.of(context).textTheme.bodySmall,
                                        )),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.bookmark,
                                      color: Colors.white10,
                                    ),
                                    Icon(
                                      index == 1 ? Icons.check : Icons.add,
                                      color: Appcolors.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}