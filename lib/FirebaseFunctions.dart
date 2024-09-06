 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app_c11/movie_model_watchList.dart';

class FirebaseFunctions{
 static CollectionReference<MovieModelWatchList>getMoviesCollection(){
  return  FirebaseFirestore.instance.collection('Movies').
    withConverter<MovieModelWatchList>(
      fromFirestore: (snapshot,_) {
        return MovieModelWatchList.fromJson( snapshot.data()!);
      },toFirestore: (movie,_ ){
      return movie.toJson();
    },
    );
  }
  static Future<void> addMovie(MovieModelWatchList movie){
    var collection=getMoviesCollection();
    var docRef=collection.doc();
    movie.id=docRef.id;
    return docRef.set(movie);
  }
 }