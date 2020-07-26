abstract class MapConvertible {
  Map<dynamic, dynamic> toMap();

  MapConvertible fromMap(Map<dynamic, dynamic> map);
}

class Movie extends MapConvertible {
  final int id;
  final String imdbId;
  final String name;
  final String imageUrl;
  final String year;
  int watchedOn; // sql doesn't support dates
  int watchedTimes;

  Movie({
    this.id,
    this.imdbId,
    this.name,
    this.imageUrl,
    this.year,
    this.watchedOn,
    this.watchedTimes,
  });

  @override
  Movie fromMap(Map map) {
    return Movie(
      id: map['id'],
      imdbId: map['imdbId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      year: "${map['year']}",
      watchedOn: map['watchedOn'],
      watchedTimes: map['watchedTimes'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'imdbId': imdbId, 'name': name, 'imageUrl': imageUrl, 'year': year, 'watchedOn': watchedOn};
  }
}
