import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/task_bloc.dart';
import '../model/task.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task?"),
        content: Text("Are you sure you want to delete '${task.title}'?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Delete"),
            onPressed: () {
              Navigator.pop(context);

              context.read<TaskBloc>().add(DeleteTask(task.id));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Task deleted: ${task.title}")),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(
                child: Text(
                  "No tasks yet.\nTap + to add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (_, index) {
                final task = state.tasks[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                      "${task.status.name.toUpperCase()} • ${task.description.isEmpty ? "No description" : task.description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, task),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskFormScreen(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TaskFormScreen(),
            ),
          );
        },
      ),
    );
  }
}
