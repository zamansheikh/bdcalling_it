import 'package:bdcalling_it/models/task_model.dart';
import 'api_service.dart';

class TaskService {
  final ApiService _apiService;

  TaskService(this._apiService);

  Future<List<TaskModel>> fetchAllTasks(String token) async {
    final response = await _apiService.getAllTasks(token);
    if (response['status'] == "Success" &&
        response['data']['myTasks'] != null) {
      List<dynamic> tasksJson = response['data']['myTasks'];
      return tasksJson.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch tasks');
    }
  }

  Future<TaskModel> fetchTaskDetails(String taskId, String token) async {
    final response = await _apiService.getTask(taskId: taskId, token: token);
    if (response['success'] == true && response['task'] != null) {
      return TaskModel.fromJson(response['task']);
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch task details');
    }
  }

  Future<void> createTask(
      String title, String description, String token) async {
    final response = await _apiService.createTask(
      title: title,
      description: description,
      token: token,
    );
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create task');
    }
  }

  Future<void> deleteTask(String taskId, String token) async {
    final response = await _apiService.deleteTask(taskId: taskId, token: token);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete task');
    }
  }
}
