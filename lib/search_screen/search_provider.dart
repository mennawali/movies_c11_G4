import 'package:flutter/material.dart';

import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/search_screen/searchresult..dart';
import 'package:movies_app_c11/search_screen/movies.dart';

class SearchProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;
  String _error = '';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> searchMovies(String movieName) async {
    _isLoading = true;
    notifyListeners();
    try {
      SearchResult searchResults =
      await ApiManager.searchMoviesByName(movieName);
      List<Movie> moviesList = searchResults.results ?? [];

      // Fetch actors for each movie
      for (Movie movie in moviesList) {
        if (movie.id != null) {
          List<String> actors = await ApiManager.getMovieCredits(movie.id!);
          movie.actors = actors;
        }
      }

      _movies = moviesList;
      _error = '';
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}