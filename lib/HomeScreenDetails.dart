
import 'package:flutter/material.dart';
import 'package:movies_app_c11/Browse.dart';
import 'package:movies_app_c11/HomePage.dart';
import 'package:movies_app_c11/WatchList.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/movie_model_watchList.dart';
import 'package:movies_app_c11/FirebaseFunctions.dart';
import 'package:movies_app_c11/MovieDetails.dart';
import 'package:movies_app_c11/Similar Movies.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const String routeName = 'homeScreenDetails';


  Future<List<Results>> fetchSimilarMovies(int movieId) async {
    final similarMovies = await ApiManager.getSimilarMovies(movieId);
    return similarMovies.results ?? [];
  }

  Widget buildMovieInfo(Results movie) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow[700]),
              const SizedBox(width: 4),
              Text(
                '${movie.voteAverage ?? 0}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Text(
            movie.title ?? "No Title",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${movie.releaseDate?.split('-')[0] ?? "N/A"}',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)?.settings.arguments as int;

    return Scaffold(
      backgroundColor: Color(0xff131313),
      appBar: AppBar(
        title: FutureBuilder<MovieDetails>(
          future: ApiManager.getMovieDetails(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Text(
                snapshot.data?.title ?? "Movie Details",
                style: TextStyle(color: Colors.white),
              );
            }
            return Text('Movie Details');
          },
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: FutureBuilder<MovieDetails>(
        future: ApiManager.getMovieDetails(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong",
                    style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData) {
            return Center(
                child: Text("No details available",
                    style: TextStyle(color: Colors.white)));
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
                  child: Text(
                    movieDetails.title ?? "No Title",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        '${movieDetails.releaseDate?.split('-')[0] ?? "N/A"}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${movieDetails.runtime} min',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
                                  imageUrl: 'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}',
                                  releaseDate: movieDetails.releaseDate ?? "",
                                );

                                try {
                                  await FirebaseFunctions.addMovie(movie);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Movie added to watchlist!'),
                                    ),
                                  );
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to add movie to watchlist'),
                                    ),
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(Icons.bookmark, color: Colors.grey[800]),
                                  ),
                                  Icon(Icons.add, color: Colors.white, size: 24),
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
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  genre.name ?? "",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              movieDetails.overview ?? "No overview available",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow[700]),
                                const SizedBox(width: 4),
                                Text(
                                  '${movieDetails.voteAverage ?? 0}',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
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
                      Text(
                        'More Like This',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<List<Results>>(
                        future: fetchSimilarMovies(id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Failed to load similar movies",
                                    style: TextStyle(color: Colors.white)));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                                child: Text("No similar movies available",
                                    style: TextStyle(color: Colors.white)));
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
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 180, // Ensure consistent height
                                      ),
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: GestureDetector(
                                          onTap: () async {
                                            final movieToAdd = MovieModelWatchList(
                                              id: movie.id.toString(),
                                              title: movie.title ?? "",
                                              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                              releaseDate: movie.releaseDate ?? "",
                                            );

                                            try {
                                              await FirebaseFunctions.addMovie(movieToAdd);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Movie added to watchlist!'),
                                                ),
                                              );
                                            } catch (error) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Failed to add movie to watchlist'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Icon(Icons.bookmark, color: Colors.grey[800], size: 30),
                                              Icon(Icons.add, color: Colors.white, size: 24),
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
      bottomNavigationBar:Container(
        color:Color(0xff1a1a1a) ,
        child: Row(
          children: [
            Spacer(),
            IconButton(
                onPressed:() {
                  Navigator.pushNamed(context,HomePage.routeName);
                }, icon:Icon(Icons.home_sharp,
              color: Colors.white,
            )),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context, '');
            }, icon:Icon(Icons.search,color:Colors.white)),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context,Browse.routeName);
            }, icon:Icon(Icons.movie_creation,color:Colors.white)),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context,WatchKListScreen.routeName);
            }, icon:Icon(Icons.collections_bookmark,color:Colors.white)),
            Spacer(),

          ],

        ),
      ),
    );
  }
}
