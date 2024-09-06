import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const String routeName = 'homeScreenDetails';

  final String title;
  final String? backdropPath;
  final String? releaseDate;
  final String? overview;

  MovieDetailsScreen({
    required this.title,
    this.backdropPath,
    this.releaseDate,
    this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (backdropPath != null)
              Image.network(
                "https://image.tmdb.org/t/p/w500$backdropPath",
                fit: BoxFit.cover,
              ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Release Date: ${releaseDate ?? 'Unknown'}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Overview:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              overview ?? 'No Overview Available',
              style: TextStyle(fontSize: 16),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
