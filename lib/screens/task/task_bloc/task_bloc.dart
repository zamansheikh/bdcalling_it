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
          final token = await authService.getToken();
          final tasks = await taskService.fetchAllTasks(token!);
          emit(TaskLoaded(tasks));
        } catch (e) {
          emit(TaskError(e.toString()));
        }
      },
    );
  }
}
