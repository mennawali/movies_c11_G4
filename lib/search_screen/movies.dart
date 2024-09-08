class Movie {
  int? id;
  String? title;
  String? overview;
  String? posterPath;
  String? releaseDate;
  List<String>? actors;

  Movie(
      {this.id,
        this.title,
        this.overview,
        this.posterPath,
        this.releaseDate,
        this.actors});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id']; // Add movie ID
    title = json['title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    actors = []; // Actors will be fetched separately
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['overview'] = overview;
    map['poster_path'] = posterPath;
    map['release_date'] = releaseDate;
    map['actors'] = actors;
    return map;
  }

  String getYear() {
    return releaseDate != null && releaseDate!.isNotEmpty
        ? releaseDate!.split('-')[0]
        : 'Unknown Year';
  }
}