import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../bloc/task_bloc.dart';
import '../model/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  TaskStatus _status = TaskStatus.pending;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleCtrl.text = widget.task!.title;
      _descCtrl.text = widget.task!.description;
      _status = widget.task!.status;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<TaskBloc>();

    if (widget.task != null) {
      final updated = widget.task!.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        status: _status,
      );

      bloc.add(UpdateTask(updated));
    } else {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        status: _status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bloc.add(AddTask(newTask));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : "Create Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Title *",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: TaskStatus.values
                    .map(
                      (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.name.toUpperCase()),
                  ),
                )
                    .toList(),
                onChanged: (val) {
                  setState(() => _status = val!);
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  child: Text(isEdit ? "Update Task" : "Save Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
