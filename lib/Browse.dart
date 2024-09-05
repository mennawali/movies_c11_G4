import 'package:flutter/material.dart';
import 'package:movies_app_c11/HomePage.dart';
import 'package:movies_app_c11/WatchList.dart';
import 'package:movies_app_c11/api_manager.dart'; // Import ApiManager
import 'package:movies_app_c11/BrowseCategory.dart'; // Import BrowseCategory class
import 'package:movies_app_c11/DisplayingMoviesByCategory.dart'; // Import the new MoviesByCategoryScreen

class Browse extends StatefulWidget {
  static const String routeName = 'browse';

  const Browse({super.key});

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late Future<BrowseCategory> _browseCategoryFuture;

  @override
  void initState() {
    super.initState();
    _browseCategoryFuture = ApiManager.getBrowseCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Browse Category'),
      ),
      backgroundColor: Color(0xff131313),
      body: FutureBuilder<BrowseCategory>(
        future: _browseCategoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.genres == null) {
            return Center(child: Text('No data available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data!.genres!.length,
              itemBuilder: (context, index) {
                var genre = snapshot.data!.genres![index];
                String imageUrl = 'assets/images/Migration.jpg';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesByCategoryScreen(
                          categoryId: genre.id!,
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageUrl),
                          fit: BoxFit.cover,
                          opacity: 100,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          genre.name ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
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
