import 'dart:convert';

import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/data/models/responses/auth_response.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/features/auth/repositories/auth_local_repository.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {

  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();

  Future<AuthResponse> signUp(String name, String email, String password) async {
    try  {
      final response = await http.post(
          Uri.parse(AppConstants.baseUrl + ApiConstants.login),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(body);
        return authResponse;
      }
      throw Exception("Error: ${body['message'] ?? body['error']}");
    } catch(e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> logIn(String email, String password) async {
    try  {
      final response = await http.post(
       Uri.parse(AppConstants.baseUrl + ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(body);
        return authResponse;
      }
      throw "${body['message'] ?? body['error']}";
    } catch(e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if(token == null) {
        return null;
      }
      final response = await http.get(
        Uri.parse(AppConstants.baseUrl + ApiConstants.getuserdata),
        headers: {
          'Content-Type': 'application/json',
          AppConstants.tokenKey: token,
        }
      ).timeout(Duration(seconds: 5));
      final body = jsonDecode(response.body);
      if(response.statusCode == 202) {
        final user = UserModel.fromJson(body);
        return user;
      }
      return null;
    } catch(e) {
      final user = await authLocalRepository.getUser();
      return user;
    }
  }


}