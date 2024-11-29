import 'dart:convert';

import 'package:bdcalling_it/core/dependency_injector.dart';
import 'package:bdcalling_it/models/task_model.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bdcalling_it/services/task_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;
  final AuthService authService;
  TaskBloc({
    required this.taskService,
    required this.authService,
  }) : super(TaskInitial()) {
    on<FetchTask>(
      (event, emit) async {
        emit(TaskLoading());
        try {
          var token = await authService.getToken();

          final tasks = await taskService.fetchAllTasks(
            token!,
          );
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );
    on<TaskDelete>(
      (event, emit) async {
        List<TaskModel> tasks = (state as TaskLoaded).tasks;
        emit(TaskLoading());
        try {
          var token = await authService.getToken();
          await taskService.deleteTask(event.task.id, json.decode(token!));
          sl<TaskBloc>().add(FetchTask());
        } catch (e) {
          emit(TaskLoaded(tasks));
        }
      },
    );
    on<CreateTask>(
      (event, emit) async {
        List<TaskModel> tasks = (state as TaskLoaded).tasks;
        emit(TaskLoading());
        try {
          var token = await authService.getToken();

          await taskService.createTask(
              event.title, event.description, json.decode(token!));

          sl<TaskBloc>().add(FetchTask());
        } catch (e) {
          emit(TaskError(e.toString()));
          await Future.delayed(Duration(seconds: 2));
          sl<TaskBloc>().add(FetchTask());
        }
      },
    );
  }
}
