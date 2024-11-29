import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  static const String baseUrl = 'http://139.59.65.225:8052';

  // Authentication Endpoints
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String address,
    File? profileImage,
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/user/register'));

    request.fields['firstName'] = firstName;
    request.fields['lastName'] = lastName;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['address'] = address;

    if (profileImage != null) {
      var mimeType = lookupMimeType(profileImage.path);
      var multipartFile = await http.MultipartFile.fromPath(
          'file', profileImage.path,
          contentType: MediaType.parse(mimeType ?? 'image/jpeg'));
      request.files.add(multipartFile);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getUser({required String token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/my-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> activateUser({
    required String email,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/activate-user'),
      body: json.encode({
        'email': email,
        'code': code,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return json.decode(response.body);
  }

  // Task Endpoints
  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/task/create-task'),
      body: json.encode({
        'title': title,
        'description': description,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getAllTasks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/task/get-all-task'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getTask({
    required String taskId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/task/get-task/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteTask({
    required String taskId,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/task/delete-task/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body);
  }
}
