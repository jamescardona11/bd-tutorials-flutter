import 'package:flutter/material.dart';
import 'package:moor_example/data/moor_database.dart';
import 'package:moor_example/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = Database();

    return MultiProvider(
      providers: [
        Provider(create: (_) => db.taskDao),
        Provider(create: (_) => db.tagDao),
      ],
      child: MaterialApp(
        title: 'Material App',
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );
  }
}
