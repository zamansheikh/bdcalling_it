import 'package:bdcalling_it/core/routes/route_names.dart';
import 'package:bdcalling_it/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:bdcalling_it/screens/task/task_bloc/task_bloc.dart';
import 'package:bdcalling_it/screens/task/task_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    initializeTask();
  }

  void initializeTask() async {
    context.read<TaskBloc>().add(FetchTask());
  }

  void _refreshTasks() {
    context.read<TaskBloc>().add(FetchTask());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(UserLoggedOut());
          },
        ),
        title: const Text('Task List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TaskError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is TaskLoaded) {
            final tasks = state.tasks;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          task: task,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      context.read<TaskBloc>().add(TaskDelete(task));
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
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.createTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
