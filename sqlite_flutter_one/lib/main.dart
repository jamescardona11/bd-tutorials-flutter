import 'package:flutter/material.dart';
import 'package:sqlite_flutter_one/data/OMDBClient.dart';
import 'package:sqlite_flutter_one/screens/AddMoviePage.dart';
import 'package:sqlite_flutter_one/screens/ItemDetailPage.dart';
import 'package:sqlite_flutter_one/screens/MoviesListPage.dart';
import 'package:provider/provider.dart';

import 'Storage.dart';
import 'data/SqlitePersistence.dart';
import 'models/Movie.dart';
import 'models/MovieTrackerApp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const apiKey = '57718d96';
  static var provider = MovieTrackerApp(OMDBClient(apiKey), null);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Storage>(
      future: Storage.createFrom(
        future: SqlitePersistence.create(),
      ),
      builder: (context, snapshot) {
        final repository = snapshot.data;
        provider = MovieTrackerApp(OMDBClient(apiKey), repository);

        return MultiProvider(
          providers: [ChangeNotifierProvider.value(value: provider)],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Color(0xff006837), primaryColorDark: Color(0xff004012), accentColor: Color(0xffc75f00)),
            home: MoviesListPage(),
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  return _makeRoute(context: context, routeName: settings.name, arguments: settings.arguments);
                },
                maintainState: true,
                fullscreenDialog: false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _makeRoute({@required BuildContext context, @required String routeName, Object arguments}) {
    final Widget child = _buildRoute(
      context: context,
      routeName: routeName,
      arguments: arguments,
    );
    return child;
  }

  Widget _buildRoute({
    @required BuildContext context,
    @required String routeName,
    Object arguments,
  }) {
    switch (routeName) {
      case '/list':
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: provider,
            )
          ],
          child: MoviesListPage(),
        );
      case '/filter':
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: provider,
            )
          ],
          child: MoviesListPage(),
        );
      case '/stats':
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: provider,
            )
          ],
          child: MoviesListPage(),
        );
      case '/details':
        final map = arguments as Map<String, dynamic> ?? Map();
        final item = map['item'] as Movie;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: provider,
            )
          ],
          child: ItemDetailPage(item: item),
        );
      case '/add':
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: provider,
            )
          ],
          child: AddMoviePage(),
        );
      default:
        return Container();
    }
  }
}
