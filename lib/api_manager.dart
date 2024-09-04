import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app_c11/PopularMovies.dart';

class ApiManager {
  static Future<PopularMovies> getPopularMovies() async {
    // Corrected API URL and parameters
    Uri url = Uri.https('api.themoviedb.org', '/3/movie/popular', {
      'api_key': '86199a6c3796f9c1d6a1a79fca08dea4',
      'language': 'en-US',
      'page': '1',
    });

    // Making the HTTP GET request
    http.Response response = await http.get(url);

    // Check if the response is successful
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      PopularMovies popularMovies = PopularMovies.fromJson(json);
      return popularMovies;
    } else {
      // Throw an error if the response is not successful
      throw Exception('Failed to load popular movies. Status code: ${response.statusCode}');
    }
  }
}