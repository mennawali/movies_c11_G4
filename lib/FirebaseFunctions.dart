import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:movies_app_c11/movie_model_watchList.dart';

class FirebaseFunctions {
  // Get a reference to the movies collection
  static CollectionReference<MovieModelWatchList> getMoviesCollection() {
    return FirebaseFirestore.instance.collection('Movies').withConverter<MovieModelWatchList>(
      fromFirestore: (snapshot, _) {
        return MovieModelWatchList.fromJson(snapshot.data()!);
      },
      toFirestore: (movie, _) {
        return movie.toJson();
      },
    );
  }

  // Add a movie to the Firestore collection
  static Future<void> addMovie(MovieModelWatchList movie) async {
    var collection = getMoviesCollection();
    var docRef = collection.doc();
    movie.id = docRef.id;
    return docRef.set(movie);
  }

  // Delete a movie from the Firestore collection by its ID
  static Future<void> deleteMovie(String id, BuildContext context) async {
    try {
      var collection = getMoviesCollection();
      await collection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie removed from watchlist')),
      );
    } catch (e) {
      print('Error deleting movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove movie')),
      );
    }
  }
}
