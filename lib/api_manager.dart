import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app_c11/PopularMovies.dart';
import 'package:movies_app_c11/UpComing_Movies.dart';
import 'package:movies_app_c11/TopRated.dart';
import 'package:movies_app_c11/BrowseCategory.dart';
import 'package:movies_app_c11/MoviesOfCategory.dart';
import 'package:movies_app_c11/MovieDetails.dart';


class ApiManager {
  static Future<PopularMovies> getPopularMovies() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/popular', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return PopularMovies.fromJson(json);
    } else {
      throw Exception(
          'Failed to load popular movies. Status code: ${response.statusCode}');
    }
  }

  static Future<UpComing_Movies> getUpComingMovies() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/upcoming', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return UpComing_Movies.fromJson(json);
    } else {
      throw Exception(
          'Failed to load upcoming movies. Status code: ${response.statusCode}');
    }
  }

  static Future<Top_Rated> getTopRatedMovies() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/top_rated', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Top_Rated.fromJson(json);
    } else {
      throw Exception(
          'Failed to load top rated movies. Status code: ${response.statusCode}');
    }
  }

  static Future<BrowseCategory> getBrowseCategories() async {
    Uri url = Uri.https('api.themoviedb.org', '/3/genre/movie/list', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return BrowseCategory.fromJson(json);
    } else {
      throw Exception(
          'Failed to load browse categories. Status code: ${response.statusCode}');
    }
  }

  // New method to fetch movies by category
  static Future<MoviesOfCategory> getMoviesByCategory(int genreId) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/discover/movie', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'sort_by': 'popularity.desc',
      'with_genres': genreId.toString(),
      'page': '1',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return MoviesOfCategory.fromJson(json);
    } else {
      throw Exception(
          'Failed to load movies by category. Status code: ${response.statusCode}');
    }
  }

  // New method to fetch movie details by ID
  static Future<MovieDetails> getMovieDetails(int movieId) async {
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/$movieId', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
    });

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return MovieDetails.fromJson(json);
    } else {
      throw Exception(
          'Failed to load movie details. Status code: ${response.statusCode}');
    }
  }
}
