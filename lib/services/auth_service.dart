import 'dart:io';
import 'package:bdcalling_it/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String address,
    File? profileImage,
  }) async {
    try {
      final response = await _apiService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        address: address,
        profileImage: profileImage,
      );
      return response;
    } catch (e) {
      return {
        'status': 'Error',
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      if (response['status'] == 'Success') {
        // Store token and user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', response['data']['token']);
        await prefs.setString('user_email', response['data']['user']['email']);
      }

      return response;
    } catch (e) {
      return {
        'status': 'Error',
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> activateUser({
    required String email,
    required String code,
  }) async {
    try {
      return await _apiService.activateUser(
        email: email,
        code: code,
      );
    } catch (e) {
      return {
        'status': 'Error',
        'message': e.toString(),
      };
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }
  Future<UserModel?> getUser(String token) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await _apiService.getUser(token: token);
      prefs.setString('user_email', response['data']['email']);
      return UserModel.fromJson(response['data']);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_email');
  }
}
