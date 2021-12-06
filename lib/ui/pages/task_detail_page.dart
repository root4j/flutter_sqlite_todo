import 'package:flutter/material.dart';
import 'package:flutter_sqlite_todo/data/models/task_model.dart';
import 'package:flutter_sqlite_todo/domain/controllers/task_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({Key? key}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final bool _editing = Get.arguments[0];
  late TaskModel task;

  final controllerContent = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      task = Get.arguments[1];
      controllerContent.text = task.content;
      controllerDate.text = DateFormat('yyyy-MM-dd').format(task.date);
    } else {
      controllerContent.text = "";
      controllerDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    TaskController taskController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? task.content : Get.arguments[1]),
        actions: _editing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    // Realiza el llamado al metodo para eliminar una tarea
                    await taskController.deleteTask(task.id);
                    Get.back();
                  },
                )
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerContent,
              decoration: const InputDecoration(
                labelText: 'Task',
                contentPadding: EdgeInsets.only(left: 12),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              key: const Key('TextFieldDueDate'),
              controller: controllerDate,
              decoration: const InputDecoration(
                labelText: 'DueDate',
                contentPadding: EdgeInsets.only(left: 12),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _editing ? task.date : DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)));
                if (_selectedDate != null) {
                  controllerDate.text =
                      DateFormat('yyyy-MM-dd').format(_selectedDate);
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        String title = 'error';
                        String message = "";
                        bool showError = false;
                        if (_editing) {
                          // Llamar metodo para actualizar una tarea
                          // existente, en caso de edición
                          var user = TaskModel(
                              id: task.id,
                              content: controllerContent.text,
                              date: DateTime.parse(controllerDate.text),
                              state: task.state);
                          await taskController
                              .updateTask(user)
                              .onError((error, stackTrace) {
                            error.printError();
                            message = error.toString();
                            showError = true;
                          });
                        } else {
                          // Llamar metodo para crear una tarea
                          var user = TaskModel(
                              content: controllerContent.text,
                              date: DateTime.parse(controllerDate.text),
                              state: false);
                          await taskController
                              .addTask(user)
                              .onError((error, stackTrace) {
                            error.printError();
                            message = error.toString();
                            showError = true;
                          });
                        }
                        if (showError) {
                          Get.snackbar(title, message,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green[400],
                              duration: const Duration(milliseconds: 1500),
                              colorText: Colors.white,
                              icon: const Icon(Icons.update),
                              barBlur: 0.5);
                        } else {
                          Get.back();
                        }
                      },
                      child: const Text("SAVE"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}