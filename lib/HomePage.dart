import 'package:flutter/material.dart';
import 'package:movies_app_c11/Browse.dart';
import 'package:movies_app_c11/FirebaseFunctions.dart';
import 'package:movies_app_c11/HomeScreenDetails.dart';
import 'package:movies_app_c11/WatchList.dart';
import 'package:movies_app_c11/api_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movies_app_c11/movie_model_watchList.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131313),
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
              // CarouselSlider at the top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CarouselSlider.builder(
                  itemCount: popularMovies.length,
                  itemBuilder: (context, index, realIndex) {
                    String imageUrl = "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}";
                    String title = popularMovies[index].title ?? 'No Title';
                    String releaseDate = popularMovies[index].releaseDate ?? 'No Release Date';

                    return imageUrl.isNotEmpty ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MovieDetailsScreen.routeName,
                        arguments: popularMovies[index],
                      );
                    },
                        child:Container(
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Center(
                                  child: Icon(
                                    Icons.play_circle_sharp,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                if (index == 1)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await FirebaseFunctions.addMovie(MovieModelWatchList(
                                          title: title,
                                          imageUrl: imageUrl,
                                          releaseDate: releaseDate,
                                          id: '', // ID will be set by Firestore
                                        ));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Movie added to watchlist')),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Icon(
                                            Icons.bookmark,
                                            color: Colors.white12,
                                            size: 30,
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  releaseDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    ) : Container(
                      color: Color(0xff131313),
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
              ),

              // PageView for Popular Movies on Top-Right
              Positioned(
                top: 118,
                left: 30,
                child: Container(
                  width: 129,
                  height: 199,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: popularMovies.length,
                        itemBuilder: (context, index, realIndex) {
                          String imageUrl = "https://image.tmdb.org/t/p/w500${popularMovies[index].backdropPath ?? ''}";

                          return imageUrl.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                );
                              },
                            ),
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
                        top: 8,
                        left: 8,
                        child: GestureDetector(
                          onTap: () async {
                            var movie = popularMovies.isNotEmpty ? popularMovies[0] : null;
                            if (movie != null) {
                              await FirebaseFunctions.addMovie(MovieModelWatchList(
                                title: movie.title ?? '',
                                imageUrl: "https://image.tmdb.org/t/p/w500${movie.backdropPath ?? ''}",
                                releaseDate: movie.releaseDate ?? '',
                                id: '', // ID will be set by Firestore
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Movie added to watchlist')),
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Colors.white10,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Scrollable content
              Positioned(
                top: 350, // Adjust based on the space needed for the sections
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // New Release Section
                      Container(
                        width: double.infinity,
                        color: Colors.grey[850],
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Release',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: ApiManager.getUpComingMovies(),
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

                                var upcomingMovies = snapshot.data?.results ?? [];

                                return Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: upcomingMovies.length,
                                    itemBuilder: (context, index) {
                                      String imageUrl =
                                          "https://image.tmdb.org/t/p/w500${upcomingMovies[index].posterPath ?? ''}";

                                      return Container(
                                        width: 90,
                                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                imageUrl,
                                                fit: BoxFit.fill,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                              ),
                                              Positioned(
                                                top: 8,
                                                left: 8,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    var movie = upcomingMovies[index];
                                                    await FirebaseFunctions.addMovie(MovieModelWatchList(
                                                      title: movie.title ?? '',
                                                      imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath ?? ''}",
                                                      releaseDate: movie.releaseDate ?? '',
                                                      id: '', // ID will be set by Firestore
                                                    ));
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Movie added to watchlist')),
                                                    );
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Icon(
                                                        Icons.bookmark,
                                                        color: Colors.white10,
                                                      ),
                                                      Icon(
                                                        index == 1 ? Icons.check : Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),

                      // Top Rated Section
                      Container(
                        width: double.infinity,
                        color: Colors.grey[850],
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommended',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: ApiManager.getTopRatedMovies(),
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

                                var topRatedMovies = snapshot.data?.results ?? [];

                                return Container(
                                  height: 200, // Adjusted height for better visibility
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: topRatedMovies.length,
                                    itemBuilder: (context, index) {
                                      String imageUrl =
                                          "https://image.tmdb.org/t/p/w500${topRatedMovies[index].posterPath ?? ''}";
                                      String title = topRatedMovies[index].title ?? 'No Title';
                                      String releaseDate = topRatedMovies[index].releaseDate ?? 'No Release Date';
                                      double voteAverage = topRatedMovies[index].voteAverage ?? 0.0;

                                      return Container(
                                        width: 100,
                                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[830], // Background color
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(color: Colors.grey[700]!, width: 2.0), // Border color and width
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      imageUrl,
                                                      fit: BoxFit.cover, // Changed to cover to fit the image better
                                                      width: double.infinity,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Center(
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Positioned(
                                                      top: 8,
                                                      left: 8, // Align to the top left
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          var movie = topRatedMovies[index];
                                                          await FirebaseFunctions.addMovie(MovieModelWatchList(
                                                            title: movie.title ?? '',
                                                            imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath ?? ''}",
                                                            releaseDate: movie.releaseDate ?? '',
                                                            id: '', // ID will be set by Firestore
                                                          ));
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Movie added to watchlist')),
                                                          );
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Icon(
                                                              Icons.bookmark,
                                                              color: Colors.white10,
                                                            ),
                                                            Icon(
                                                              Icons.add,
                                                              color: Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 16.0,
                                                      ),
                                                      SizedBox(width: 4.0),
                                                      Text(
                                                        voteAverage.toStringAsFixed(1),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    title,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    releaseDate,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 4.0),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

          );
        },
      ),

      bottomNavigationBar:Container(
        color:Color(0xff1a1a1a) ,
        child: Row(
          children: [
            Spacer(),
            IconButton(
                onPressed:() {
                  Navigator.pushNamed(context,HomePage.routeName);
                }, icon:Icon(Icons.home_sharp,
              color: Colors.white,
            )),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context, '');
            }, icon:Icon(Icons.search,color:Colors.white)),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context,Browse.routeName);
            }, icon:Icon(Icons.movie_creation,color:Colors.white)),
            Spacer(),
            IconButton(onPressed:() {
              Navigator.pushNamed(context,WatchKListScreen.routeName);
            }, icon:Icon(Icons.collections_bookmark,color:Colors.white)),
            Spacer(),

          ],

        ),
      ),

    );
  }
}
