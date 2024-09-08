import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/firebase_functions.dart';
import 'package:movies_app_c11/movie%20_details/movie_details_model.dart';
import 'package:movies_app_c11/nav_bar.dart';
import 'package:movies_app_c11/similar_movies.dart';
import 'package:movies_app_c11/watch_list/whatch_list_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const String routeName = 'homeScreenDetails';

  Future<List<Results>> fetchSimilarMovies(int movieId) async {
    final similarMovies = await ApiManager.getSimilarMovies(movieId);
    return SimilarMovies.results ?? [];
  }

  Widget buildMovieInfo(Results movie) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Appcolors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Appcolors.yellowColor),
              const SizedBox(width: 4),
              Text(
                '${movie.voteAverage ?? 0}',
                style: TextStyle(color: Appcolors.whiteColor),
              ),
            ],
          ),
          Text(
            movie.title ?? "No Title",
            style: TextStyle(
              color: Appcolors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${movie.releaseDate?.split('-')[0] ?? "N/A"}',
            style: TextStyle(color: Appcolors.whiteColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)?.settings.arguments as int;

    return Scaffold(
        backgroundColor: Appcolors.primary,
        appBar: AppBar(
          title: FutureBuilder<movie_details_model>(
            future: ApiManager.getMovieDetails(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Text(
                  snapshot.data?.title ?? "Movie Details",
                  style: TextStyle(color: Appcolors.whiteColor),
                );
              }
              return Text('Movie Details');
            },
          ),
          backgroundColor: Appcolors.secondary,
        ),
        body: FutureBuilder<movie_details_model>(
          future: ApiManager.getMovieDetails(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text("Something went wrong",
                      style: TextStyle(color: Appcolors.whiteColor)));
            }
            if (!snapshot.hasData) {
              return Center(
                  child: Text("No details available",
                      style: TextStyle(color: Appcolors.whiteColor)));
            }

            var movieDetails = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${movieDetails.backdropPath}',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(movieDetails.title ?? "No Title",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 24)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                            '${movieDetails.releaseDate?.split('-')[0] ?? "N/A"}',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 10),
                        Text('${movieDetails.runtime} min',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}',
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              left: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final movie = MovieModelWatchList(
                                    id: movieDetails.id.toString(),
                                    title: movieDetails.title ?? "",
                                    imageUrl:
                                    'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}',
                                    releaseDate: movieDetails.releaseDate ?? "",
                                  );

                                  try {
                                    await FirebaseFunctions.addMovie(movie);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Movie added to watchlist!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      ),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to add movie to watchlist',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      ),
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Icon(Icons.bookmark,
                                          color: Appcolors.secondary),
                                    ),
                                    Icon(Icons.add,
                                        color: Appcolors.whiteColor, size: 24),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: movieDetails.genres!
                                    .map((genre) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Appcolors.secondary,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(genre.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                          fontWeight:
                                          FontWeight.w400)),
                                ))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  movieDetails.overview ??
                                      "No overview available",
                                  style:
                                  Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Appcolors.yellowColor),
                                  const SizedBox(width: 4),
                                  Text('${movieDetails.voteAverage ?? 0}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Similar Movies Section
                  Container(
                    color: Colors.grey[850],
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('More Like This',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w400)),
                        const SizedBox(height: 8),
                        FutureBuilder<List<Results>>(
                          future: fetchSimilarMovies(id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Failed to load similar movies",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text("No similar movies available",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall));
                            }

                            return SizedBox(
                              height: 300, // Set a fixed height for the row
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final movie = snapshot.data![index];
                                  return Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Appcolors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height:
                                          180, // Ensure consistent height
                                        ),
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final movieToAdd =
                                              MovieModelWatchList(
                                                id: movie.id.toString(),
                                                title: movie.title ?? "",
                                                imageUrl:
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                releaseDate:
                                                movie.releaseDate ?? "",
                                              );

                                              try {
                                                await FirebaseFunctions
                                                    .addMovie(movieToAdd);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Movie added to watchlist!',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall),
                                                  ),
                                                );
                                              } catch (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to add movie to watchlist',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                Icon(Icons.bookmark,
                                                    color: Appcolors.secondary,
                                                    size: 30),
                                                Icon(Icons.add,
                                                    color: Appcolors.whiteColor,
                                                    size: 24),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: buildMovieInfo(movie),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: NavBar());
  }
}