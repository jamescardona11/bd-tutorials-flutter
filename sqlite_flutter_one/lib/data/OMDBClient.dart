import 'package:http/http.dart';
import 'package:sqlite_flutter_one/models/MovieSearchResponse.dart';

class OMDBClient {
  final String apiKey;

  OMDBClient(this.apiKey);

  static const String baseUrl = 'www.omdbapi.com';

  Future<MovieSearchResponse> findMovies(String query) async {
    final uri = Uri.http(baseUrl, '', {
      's': query.trim(),
      'apiKey': apiKey,
    });
    final response = await get(uri);
    return movieSearchResponseFromJson(response.body);
  }
}
