import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/search_screen/search_provider.dart';

class SearchTab extends SearchDelegate<String> {
  final SearchProvider searchProvider;
  late Future<void> searchFuture;

  SearchTab({required this.searchProvider}) {
    searchFuture = searchProvider.searchMovies(query);
  }

  @override
  TextStyle? get searchFieldStyle => TextStyle(
    color: Appcolors.primary,
    fontSize: 16.0,
  );

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Appcolors.primary, width: 1),
    ),
    fillColor: Appcolors.whiteColor,
    filled: true,
    hintStyle: TextStyle(color: Appcolors.secondary),
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Appcolors.secondary),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Appcolors.secondary),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchFuture =
        searchProvider.searchMovies(query); // Update future with the new query

    return FutureBuilder(
      future: searchFuture,
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Appcolors.primary,
            child: Center(
              child: CircularProgressIndicator(color: Appcolors.secondary),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red)));
        }

        final movies = searchProvider.movies;

        if (movies.isEmpty) {
          return Container(
            color: Appcolors.primary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_movies,
                    size: 100,
                    color: Appcolors.secondary,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'No result found',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: Appcolors.primary,
          child: ListView.separated(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(12), // Border radius of 12
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback image if the network image fails to load
                            return Icon(
                              Icons.movie_creation_sharp,
                              color: Appcolors.secondary,
                              size: 100,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.title ?? 'No Title',
                              style: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: 4),
                          Text(
                            movie.getYear(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Appcolors.secondary),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movie.actors != null && movie.actors!.isNotEmpty
                                ? 'Heroes: ${movie.actors!.take(3).join(', ')}' // Showing top 3 heroes
                                : 'No Heroes Found',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Appcolors.secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Appcolors.secondary,
              thickness: 1,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Container(
        color: Appcolors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.local_movies, size: 100, color: Appcolors.secondary),
            SizedBox(height: 5),
            Text(
              'Search for your favorite movies',
              style: TextStyle(fontSize: 13, color: Appcolors.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}