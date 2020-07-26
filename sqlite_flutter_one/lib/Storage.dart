
import 'data/SqlitePersistence.dart';
import 'models/Movie.dart';

class Storage {
  final SqlitePersistence _repository;

  static Future<Storage> createFrom({Future<SqlitePersistence> future}) async {
    final repository = await future;
    final ret = Storage(repository);

    return ret;
  }

  Storage(this._repository);

  void addToWatched(Movie movie) async {
    await _repository?.createOrUpdateObject(movie.id, movie.toMap());
  }

  Future<List<Movie>> watchedMovies(String query) async {
    final objects = query?.isNotEmpty == true
        ? await _repository.findObjects(query)
        : await _repository.getUniqueObjects();
    return objects.map((map) => Movie().fromMap(map)).toList();
  }

  void removeFromWatched(Movie movie) async {
    await _repository.removeObject(movie.id);
  }
}
