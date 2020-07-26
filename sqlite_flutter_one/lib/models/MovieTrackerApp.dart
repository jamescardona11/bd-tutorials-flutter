import 'package:flutter/material.dart';
import 'package:sqlite_flutter_one/data/OMDBClient.dart';

import '../Storage.dart';

class MovieTrackerApp with ChangeNotifier {
  MovieTrackerApp(this._movieRepository, this._storage);

  final OMDBClient _movieRepository;

  final Storage _storage;

  OMDBClient get movieRepository => _movieRepository;

  Storage get storage => _storage;

  void refresh() {
    notifyListeners();
  }
}
