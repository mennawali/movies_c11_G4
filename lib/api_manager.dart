import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app_c11/browes_screen/BrowseCategory.dart';
import 'package:movies_app_c11/browes_screen/MoviesOfCategory.dart';
import 'package:movies_app_c11/home/PopularMovies.dart';
import 'package:movies_app_c11/home/TopRated.dart';
import 'package:movies_app_c11/home/UpComing_Movies.dart';
import 'package:movies_app_c11/movie%20_details/movie_details_model.dart';
import 'package:movies_app_c11/search_screen/searchresult..dart';
import 'package:movies_app_c11/similar_movies.dart';
class ApiManager {
  static const _apiKey = '86199a6c3796f9c1d6a1a79fca08dea4';

  static Future<PopularMovies> getPopularMovies() async {
    final url = Uri.https('api.themoviedb.org', '/3/movie/popular', {
      'api_key': _apiKey,
      'language': 'en-US',
      'page': '1',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return PopularMovies.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load popular movies: ${response.body}');
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      print('Error fetching popular movies: $e');
      rethrow;
    }
  }

  static Future<UpComing_Movies> getUpComingMovies() async {
    final url = Uri.https('api.themoviedb.org', '/3/movie/upcoming', {
      'api_key': _apiKey,
      'language': 'en-US',
      'page': '1',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UpComing_Movies.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load upcoming movies: ${response.body}');
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      rethrow;
    }
  }

  static Future<Top_Rated> getTopRatedMovies() async {
    final url = Uri.https('api.themoviedb.org', '/3/movie/top_rated', {
      'api_key': _apiKey,
      'language': 'en-US',
      'page': '1',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Top_Rated.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load top rated movies: ${response.body}');
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      print('Error fetching top rated movies: $e');
      rethrow;
    }
  }

  static Future<BrowseCategory> getBrowseCategories() async {
    final url = Uri.https('api.themoviedb.org', '/3/genre/movie/list', {
      'api_key': _apiKey,
      'language': 'en-US',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return BrowseCategory.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load browse categories: ${response.body}');
        throw Exception('Failed to load browse categories');
      }
    } catch (e) {
      print('Error fetching browse categories: $e');
      rethrow;
    }
  }

  static Future<MoviesOfCategory> getMoviesByCategory(int genreId) async {
    final url = Uri.https('api.themoviedb.org', '/3/discover/movie', {
      'api_key': _apiKey,
      'language': 'en-US',
      'sort_by': 'popularity.desc',
      'with_genres': genreId.toString(),
      'page': '1',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return MoviesOfCategory.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load movies by category: ${response.body}');
        throw Exception('Failed to load movies by category');
      }
    } catch (e) {
      print('Error fetching movies by category: $e');
      rethrow;
    }
  }

  static Future<movie_details_model> getMovieDetails(int movieId) async {
    final url = Uri.https('api.themoviedb.org', '/3/movie/$movieId', {
      'api_key': _apiKey,
      'language': 'en-US',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return movie_details_model.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load movie details: ${response.body}');
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      rethrow;
    }
  }

  static Future<SimilarMovies> getSimilarMovies(int movieId) async {
    final url = Uri.https('api.themoviedb.org', '/3/movie/$movieId/similar', {
      'api_key': _apiKey,
      'language': 'en-US',
      'page': '1',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return SimilarMovies.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load similar movies: ${response.body}');
        throw Exception('Failed to load similar movies');
      }
    } catch (e) {
      print('Error fetching similar movies: $e');
      rethrow;
    }
  }

//search
  static Future<SearchResult> searchMoviesByName(String movieName) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/search/movie', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'query': movieName,
      'page': '1',
      'include_adult': 'false',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return SearchResult.fromJson(json);
    } else {
      throw Exception(
          'Failed to search movies. Status code: ${response.statusCode}');
    }
  }

//main actors of the film
  static Future<List<String>> getMovieCredits(int movieId) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/$movieId/credits', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      // Extract the top-billed cast (heroes)
      List<dynamic> cast = json['cast'] ?? [];
      // Map the cast to a list of actor names
      List<String> actors =
      cast.map((actor) => actor['name'].toString()).toList();
      return actors;
    } else {
      throw Exception(
          'Failed to load movie credits. Status code: ${response.statusCode}');
    }
  }
}