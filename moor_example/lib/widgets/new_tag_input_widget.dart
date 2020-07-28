import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:moor_example/data/moor_database.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:provider/provider.dart';

class NewTagInput extends StatefulWidget {
  const NewTagInput({
    Key key,
  }) : super(key: key);

  @override
  _NewTagInputState createState() => _NewTagInputState();
}

class _NewTagInputState extends State<NewTagInput> {
  static const Color DEFAULT_COLOR = Colors.red;

  Color pickedTagColor = DEFAULT_COLOR;
  TextEditingController controller;
  String tagName = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          _buildTextField(context),
          _buildColorPickerButton(context),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final dao = Provider.of<TagDao>(context, listen: false);
              final task = TagsCompanion(
                name: Value(tagName),
                color: Value(pickedTagColor.value),
              );
              dao.insertTag(task);
              resetValuesAfterSubmit();
            },
          )
        ],
      ),
    );
  }

  Flexible _buildTextField(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Tag Name'),
        onChanged: (inputName) {
          tagName = inputName;
        },
      ),
    );
  }

  Widget _buildColorPickerButton(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pickedTagColor,
          ),
        ),
        onTap: () {
          _showColorPickerDialog(context);
        },
      ),
    );
  }

  Future _showColorPickerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: MaterialColorPicker(
            allowShades: false,
            selectedColor: DEFAULT_COLOR,
            onMainColorChange: (colorSwatch) {
              setState(() {
                pickedTagColor = colorSwatch;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      pickedTagColor = DEFAULT_COLOR;
      controller.clear();
    });
  }
}
