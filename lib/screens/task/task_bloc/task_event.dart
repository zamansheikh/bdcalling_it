part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class FetchTask extends TaskEvent {}