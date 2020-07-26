import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/inventory_model.dart';

import 'home_model.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<HomeModel>().getItem();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<HomeModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.06),
              child: Column(
                children: <Widget>[
                  Text(
                    'Hive Inventory',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    height: 0.9 * height,
                    child: ListView.builder(
                      itemCount: model.inventoryList.length,
                      itemBuilder: (context, index) {
                        Inventory inv = model.inventoryList[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 0.02 * height,
                            horizontal: 0.045 * width,
                          ),
                          height: 0.13 * height,
                          // width: 50.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 0.02 * width),
                                width: 0.16 * width,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.03 * height,
                                  horizontal: 0.03 * width,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      inv.name,
                                      style: TextStyle(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.01 * height,
                                    ),
                                    Text(
                                      inv.description,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0.08 * width),
                                child: PopupMenuButton(
                                  onSelected: (item) {
                                    switch (item) {
                                      case 'update':
                                        nameController.text = inv.name;
                                        descriptionController.text = inv.description;

                                        inputItemDialog(context, 'update', index);
                                        break;
                                      case 'delete':
                                        model.deleteItem(index);
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'update',
                                        child: Text('Update'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ];
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              inputItemDialog(context, 'add');
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 0.08 * width,
            ),
          ),
        );
      },
    );
  }

  inputItemDialog(BuildContext context, String action, [int index]) {
    var inventoryDb = Provider.of<HomeModel>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 40,
            ),
            height: 0.45 * height,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      action == 'add' ? 'Add Item' : 'Update Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Item name cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Item name',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Item description cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Item description',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (action == 'add') {
                            await inventoryDb.addItem(Inventory(
                              name: nameController.text,
                              description: descriptionController.text,
                            ));
                          } else {
                            await inventoryDb.updateItem(
                                index,
                                Inventory(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                ));
                          }

                          nameController.clear();
                          descriptionController.clear();

                          inventoryDb.getItem();

                          Navigator.pop(context);
                        }
                      },
                      color: Colors.green[600],
                      child: Text(
                        action == 'add' ? 'Add' : 'update',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
