import 'package:flutter/material.dart';
import 'package:moor_example/data/moor_database.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({
    Key key,
  }) : super(key: key);

  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime newTaskDate;
  String taskName = '';
  TextEditingController controller;

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
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (taskName.length > 0 && newTaskDate != null) {
                debugPrint('Here');

                final dao = Provider.of<TaskDao>(context, listen: false);
                final task = TasksCompanion(
                  name: Value(taskName),
                  dueDate: Value(newTaskDate),
                );
                dao.insertTask(task);
                resetValuesAfterSubmit();
              }
            },
          )
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Task Name'),
        onChanged: (inputName) {
          taskName = inputName;
        },
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      //newTaskDate = null; //for testing
      taskName = '';
      controller.clear();
    });
  }
}
