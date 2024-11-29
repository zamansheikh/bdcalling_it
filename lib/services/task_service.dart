import 'dart:convert';

import 'package:bdcalling_it/models/task_model.dart';
import 'api_service.dart';

class TaskService {
  final ApiService _apiService;

  TaskService(this._apiService);

  Future<List<TaskModel>> fetchAllTasks(String token) async {
    Map<String, dynamic>
        response; // = await _apiService.getAllTasks(token);//!TODO: I will fix when API is ready
    final dummyJson = """
{
    "status": "Success",
    "message": "Your Tasks found",
    "data": {
        "count": 5,
        "myTasks": [
            {
                "_id": "67446719a863e97a505db1ad",
                "title": ";alksdjf;laSKDjf",
                "description": ";alksdjf;laSKDjf",
                "creator_email": "thakursaad613@gmail.com",
                "createdAt": "2024-11-25T12:01:29.501Z",
                "updatedAt": "2024-11-25T12:01:29.501Z",
                "__v": 0
            },
            {
                "_id": "6744671ba863e97a505db1af",
                "title": ";alksdjf;laSKDjf",
                "description": ";alksdjf;laSKDjf",
                "creator_email": "thakursaad613@gmail.com",
                "createdAt": "2024-11-25T12:01:31.507Z",
                "updatedAt": "2024-11-25T12:01:31.507Z",
                "__v": 0
            },
            {
                "_id": "6744671ca863e97a505db1b1",
                "title": ";alksdjf;laSKDjf",
                "description": ";alksdjf;laSKDjf",
                "creator_email": "thakursaad613@gmail.com",
                "createdAt": "2024-11-25T12:01:32.105Z",
                "updatedAt": "2024-11-25T12:01:32.105Z",
                "__v": 0
            },
            {
                "_id": "6744671ca863e97a505db1b3",
                "title": ";alksdjf;laSKDjf",
                "description": ";alksdjf;laSKDjf",
                "creator_email": "thakursaad613@gmail.com",
                "createdAt": "2024-11-25T12:01:32.617Z",
                "updatedAt": "2024-11-25T12:01:32.617Z",
                "__v": 0
            },
            {
                "_id": "6744675aaba11e4ae5f05cef",
                "title": ";alksdjf;laSKDjf",
                "description": ";alksdjf;laSKDjf",
                "creator_email": "thakursaad613@gmail.com",
                "createdAt": "2024-11-25T12:02:34.561Z",
                "updatedAt": "2024-11-25T12:02:34.561Z",
                "__v": 0
            }
        ]
    }
}""";
    response = jsonDecode(dummyJson);

    if (response['status'] == "Success" &&
        response['data']['myTasks'] != null) {
      List<dynamic> tasksJson = response['data']['myTasks'];

      tasksJson = response['data']['myTasks'];
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
