import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/firebase_functions.dart';
import 'package:movies_app_c11/watch_list/whatch_list_model.dart';
import '../movie _details/movie_details_screen.dart';

class Recommended extends StatelessWidget {
  const Recommended({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[850],
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommended', style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 5),
          FutureBuilder(
            future: ApiManager.getTopRatedMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong!',
                      style: Theme.of(context).textTheme.titleMedium),
                );
              }

              var topRatedMovies = snapshot.data?.results ?? [];

              return SizedBox(
                height: 184,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topRatedMovies.length,
                  itemBuilder: (context, index) {
                    String imageUrl =
                        "https://image.tmdb.org/t/p/w500${topRatedMovies[index].posterPath ?? ''}";
                    String title = topRatedMovies[index].title ?? 'No Title';
                    String releaseDate =
                        topRatedMovies[index].releaseDate ?? 'No Release Date';
                    double voteAverage =
                        topRatedMovies[index].voteAverage ?? 0.0;

                    return Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[830],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Appcolors.secondary,
                          width: 2.0,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MovieDetailsScreen.routeName,
                            arguments: topRatedMovies[index].id,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 95,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8.0)),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                          var movie = topRatedMovies[index];
                                          await FirebaseFunctions.addMovie(
                                            MovieModelWatchList(
                                              title: movie.title ?? '',
                                              imageUrl:
                                              "https://image.tmdb.org/t/p/w500${movie.posterPath ?? ''}",
                                              releaseDate:
                                              movie.releaseDate ?? '',
                                              id: '', // ID will be set by Firestore
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                  'Movie added to watchlist',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                )),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Icon(
                                              Icons.bookmark,
                                              color: Appcolors.secondary,
                                            ),
                                            Icon(
                                              Icons.add,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Appcolors.yellowColor,
                                        size: 16.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(voteAverage.toStringAsFixed(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                  Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    releaseDate,
                                    style:
                                    Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}