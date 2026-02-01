import '../../../core/storage/local_storage.dart';
import '../model/task.dart';


class TaskRepository {
  final LocalStorage storage;


  TaskRepository(this.storage);


  Future<List<Task>> loadTasks() async {
    final raw = await storage.loadTasks();
    return raw.map(Task.fromJson).toList();
  }


  Future<void> saveTasks(List<Task> tasks) async {
    await storage.saveTasks(tasks.map((e) => e.toJson()).toList());
  }
}
