import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/storage/local_storage.dart';
import 'package:task_manager/features/auth/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/data/auth_repository.dart';
import 'package:task_manager/features/auth/presentation/login_screen.dart';
import 'package:task_manager/features/tasks/bloc/task_bloc.dart';
import 'package:task_manager/features/tasks/data/task_repository.dart';
import 'package:task_manager/features/tasks/presentation/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _storage = LocalStorage();

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepository(_storage))..add(CheckSession()),
        ),
        BlocProvider(
          create: (_) => TaskBloc(TaskRepository(_storage))..add(LoadTasks()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

