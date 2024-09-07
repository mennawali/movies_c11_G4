import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_c11/FirebaseFunctions.dart'; // Import the FirebaseFunctions class

class WatchKListScreen extends StatefulWidget {
  static const String routeName = 'watchlist';
  const WatchKListScreen({super.key});

  @override
  State<WatchKListScreen> createState() => _WatchKListScreenState();
}

class _WatchKListScreenState extends State<WatchKListScreen> {
  final CollectionReference _movieCollection = FirebaseFirestore.instance.collection('Movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131313),
      appBar: AppBar(
        backgroundColor: Color(0xff131313),
        title: Text('WatchList', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _movieCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text(
                'No movies in watchlist!',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var movies = snapshot.data?.docs ?? [];

          return ListView.separated(
            itemCount: movies.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[700],
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
                      : Icon(Icons.broken_image, color: Colors.white),
                ),
                title: Text(title, style: TextStyle(color: Colors.white)),
                subtitle: Text(releaseDate, style: TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    try {
                      await FirebaseFunctions.getMoviesCollection().doc(id).delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Movie removed from watchlist')),
                      );
                    } catch (e) {
                      print('Error deleting movie: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to remove movie')),
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
