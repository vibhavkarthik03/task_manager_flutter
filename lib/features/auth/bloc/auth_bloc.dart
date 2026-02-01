import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';


abstract class AuthEvent {}


class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}


class LogoutRequested extends AuthEvent {}
class CheckSession extends AuthEvent {}


abstract class AuthState {}


class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnauthenticated extends AuthState {
  final String? error;
  AuthUnauthenticated({this.error});
}


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;


  AuthBloc(this.repo) : super(AuthInitial()) {
    on<CheckSession>((event, emit) async {
      final loggedIn = await repo.checkSession();
      emit(loggedIn ? AuthAuthenticated() : AuthUnauthenticated());
    });


    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final ok = await repo.login(event.email, event.password);
      emit(ok
          ? AuthAuthenticated()
          : AuthUnauthenticated(error: "Invalid credentials"));
    });


    on<LogoutRequested>((event, emit) async {
      await repo.logout();
      emit(AuthUnauthenticated());
    });
  }
}
