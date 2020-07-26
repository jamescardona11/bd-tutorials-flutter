import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_example_one/model/inventory_model.dart';

class HomeModel extends ChangeNotifier {
  String _inventoryBox = 'inventory';
  List _inventoryList = <Inventory>[];

  List get inventoryList => _inventoryList;

  addItem(Inventory inventory) async {
    final box = await Hive.openBox<Inventory>(_inventoryBox);
    box.add(inventory);
    debugPrint('Added');
    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox<Inventory>(_inventoryBox);
    _inventoryList = box.values.toList();
    notifyListeners();
  }

  updateItem(int index, Inventory inventory) {
    final box = Hive.box<Inventory>(_inventoryBox);
    box.putAt(index, inventory);
    debugPrint('Updated');
    notifyListeners();
  }

  deleteItem(int index) {
    final box = Hive.box<Inventory>(_inventoryBox);
    box.deleteAt(index);
    getItem();
    debugPrint('Deleted');
    notifyListeners();
  }
}
