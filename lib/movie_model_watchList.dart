class MovieModelWatchList {
  String title;
  String imageUrl;
  String releaseDate;
  String id;

  MovieModelWatchList({
    this.id = '',
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
  });

  MovieModelWatchList.fromJson(Map<String, dynamic> json)
      : this(
    title: json['title'],
    imageUrl: json['imageUrl'],
    releaseDate: json['releaseDate'],
    id: json['id'] ?? '', // Default to empty string if id is not present
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'releaseDate': releaseDate,
      'id': id, // Include id in the JSON map
    };
  }
}
