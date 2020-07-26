import 'package:flutter/material.dart';
import 'package:sqlite_flutter_one/models/Movie.dart';
import 'package:sqlite_flutter_one/models/MovieTrackerApp.dart';
import 'package:sqlite_flutter_one/widgets/DebouncedTextField.dart';
import 'package:sqlite_flutter_one/widgets/MagicAppBar.dart';
import 'package:sqlite_flutter_one/widgets/MovieListItem.dart';
import 'package:provider/provider.dart';

class MoviesListPage extends StatefulWidget {
  @override
  _MoviesListPageState createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  final controller = TextEditingController();
  String _query;

  @override
  Widget build(BuildContext context) {
    final MovieTrackerApp app = Provider.of<MovieTrackerApp>(context);

    return Scaffold(
      appBar: CinephileAppBar.build(context: context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DebouncedTextField(
              debounceDuration: Duration(milliseconds: 500),
              decoration: InputDecoration(hintText: 'Search your watch history'),
              controller: controller,
              onChanged: (value) async {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Object>(
                future: app.storage?.watchedMovies(_query),
                builder: (context, snapshot) {
                  final List<Movie> items = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          '/details',
                          arguments: {'item': item},
                        ),
                        child: MovieListItem(
                          item: item,
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
