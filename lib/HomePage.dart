import 'package:flutter/material.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: ApiManager.getPopularMovies(),
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

          var popularMovies = snapshot.data?.results ?? [];

          return Stack(
            children: [
              // Display images horizontally on the top part of the screen using CarouselSlider
              CarouselSlider.builder(
                itemCount: popularMovies.length,
                itemBuilder: (context, index, realIndex) {
                  String imageUrl =
                      "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}";
                  String title = popularMovies[index].title ?? 'No Title';
                  String releaseDate = popularMovies[index].releaseDate ?? 'No Release Date';

                  return imageUrl.isNotEmpty && popularMovies[index].backdropPath != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.broken_image, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              releaseDate,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Text(
                        'No Image Available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 300,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 300),
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                ),
              ),
              Positioned(
                top: 118, // Position from the top
                left: 21, // Position from the left
                child: Container(
                  width: 129, // Width of the container
                  height: 199, // Height of the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4), // Top-left border radius
                    ),
                    color: Colors.transparent, // Transparent background
                  ),
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: popularMovies.length,
                        itemBuilder: (context, index) {
                          String imageUrl =
                              "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}";

                          return imageUrl.isNotEmpty && popularMovies[index].backdropPath != null
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover, // Ensure images cover the container
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image,
                                color: Colors.white,
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Text(
                                'No Image Available',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Stack(
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: Colors.grey,
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(),
            ],
          );
        },
      ),
    );
  }
}
