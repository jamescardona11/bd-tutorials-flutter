import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_example_one/home/home_page.dart';
import 'package:hive_example_one/model/inventory_model.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

Future<void> main() async {
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();

  Hive.registerAdapter(InventoryAdapter());
  Hive.init(directory.path);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
