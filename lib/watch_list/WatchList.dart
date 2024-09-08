import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_c11/AppColors.dart';
import 'package:movies_app_c11/firebase_functions.dart';

class WatchListScreen extends StatefulWidget {
  static const String routeName = 'watchlist';
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final CollectionReference _movieCollection =
  FirebaseFirestore.instance.collection('Movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primary,
      appBar: AppBar(
        title: Text('WatchList'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _movieCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text('No movies in watchlist!',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }

          var movies = snapshot.data?.docs ?? [];

          return ListView.separated(
            itemCount: movies.length,
            separatorBuilder: (context, index) => Divider(
              color: Appcolors.secondary,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              var movie = movies[index].data() as Map<String, dynamic>;
              String imageUrl = movie['imageUrl'] ?? '';
              String title = movie['title'] ?? 'No Title';
              String releaseDate = movie['releaseDate'] ?? 'No Release Date';
              String id = movies[index].id;

              return ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: Container(
                  width: 100, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Icon(Icons.broken_image, color: Appcolors.secondary),
                ),
                title:
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(releaseDate,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w400)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    try {
                      await FirebaseFunctions.getMoviesCollection()
                          .doc(id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              'Movie removed from watchlist',
                              style: Theme.of(context).textTheme.bodySmall,
                            )),
                      );
                    } catch (e) {
                      print('Error deleting movie: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              'Failed to remove movie',
                              style: Theme.of(context).textTheme.bodySmall,
                            )),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}