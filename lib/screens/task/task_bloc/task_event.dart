part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class FetchTask extends TaskEvent {}

final class TaskDelete extends TaskEvent {
  final TaskModel task;
  const TaskDelete(this.task);

  @override
  List<Object> get props => [task];
}

class CreateTask extends TaskEvent {
  final String title;
  final String description;
  const CreateTask({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [title, description];
}