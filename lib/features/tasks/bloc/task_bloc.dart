import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/task_repository.dart';
import '../model/task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}
class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}


class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}


class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}


abstract class TaskState {}


class TaskLoading extends TaskState {}
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repo;
  List<Task> _tasks = [];


  TaskBloc(this.repo) : super(TaskLoading()) {
    on<LoadTasks>((event, emit) async {
      _tasks = await repo.loadTasks();
      emit(TaskLoaded(_tasks));
    });


    on<AddTask>((event, emit) async {
      _tasks.add(event.task);
      await repo.saveTasks(_tasks);
      emit(TaskLoaded(List.from(_tasks)));
    });


    on<UpdateTask>((event, emit) async {
      _tasks = _tasks.map((t) => t.id == event.task.id ? event.task : t).toList();
      await repo.saveTasks(_tasks);
      emit(TaskLoaded(List.from(_tasks)));
    });


    on<DeleteTask>((event, emit) async {
      _tasks.removeWhere((t) => t.id == event.id);
      await repo.saveTasks(_tasks);
      emit(TaskLoaded(List.from(_tasks)));
    });
  }
}
