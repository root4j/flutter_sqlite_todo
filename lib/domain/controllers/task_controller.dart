import 'package:flutter_sqlite_todo/data/models/task_model.dart';
import 'package:flutter_sqlite_todo/data/repositories/task_repository.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final _tasks = <TaskModel>[].obs;
  TaskRepository repository = Get.find();
  //List<TaskModel> get getAllTasks =>

  List<TaskModel> get tasks => _tasks;

  @override
  onInit() {
    super.onInit();
    getAllTasks();
  }

  Future<void> addTask(task) async {
    // Metodo para añadir tareas
    await repository.addTask(task);
    await getAllTasks();
  }

  Future<void> getAllTasks() async {
    // Metodo para obtener todas las tareas existentes
    _tasks.value = await repository.getAllTasks();
  }

  Future<void> deleteTask(id) async {
    // Metodo para eliminar una tarea especifica
    await repository.deleteTask(id);
    await getAllTasks();
  }

  Future<void> deleteAll() async {
    // Metodo para eliminar todas las tareas
    await repository.deleteAll();
    await getAllTasks();
  }

  Future<void> updateTask(user) async {
    // Metodo para actualizar tareas de un usuario especifico
    await repository.updateTask(user);
    await getAllTasks();
  }
}
