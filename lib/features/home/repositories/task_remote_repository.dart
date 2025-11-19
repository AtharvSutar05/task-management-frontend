import 'dart:convert';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/core/utils.dart';
import 'package:frontend/data/models/task_model.dart';
import 'package:frontend/features/home/repositories/task_local_repository.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final spService = SpService();
  final taskLocalRepository = TaskLocalRepository();

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hex_color,
    required DateTime due_at,
    required String uid,
  }) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "Please sign in again!";
      }
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + ApiConstants.createTask),
        headers: {
          'Content-Type': 'application/json',
          AppConstants.tokenKey: token,
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "hex_color": hex_color,
          "due_at": due_at.toIso8601String(),
        }),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final task = TaskModel.fromJson(body);
        return task;
      }
      throw body['message'] ?? body['err'];
    } catch (e) {
      try {
        final taskModel = TaskModel(
          id: Uuid().v6(),
          uid: uid,
          title: title,
          description: description,
          due_at: due_at.toIso8601String(),
          created_at: DateTime.now().toIso8601String(),
          updated_at: DateTime.now().toIso8601String(),
          color: hexToRgb(hex_color),
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch(e) {
        rethrow;
      }
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "Please sign in again!";
      }
      final response = await http.get(
        Uri.parse(AppConstants.baseUrl + ApiConstants.getTasks),
        headers: {
          'Content-Type': 'application/json',
          AppConstants.tokenKey: token,
        },
      );
      if (response.statusCode != 200) {
        throw jsonDecode(response.body)['message'];
      }
      final tasks = jsonDecode(response.body);
      List<TaskModel> listOfTasks = [];
      for (var elem in tasks) {
        listOfTasks.add(TaskModel.fromMap(elem));
      }
      await taskLocalRepository.insertTasks(listOfTasks);
      return listOfTasks;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      throw e.toString();
    }
  }

  Future<bool> syncTasks({
    required List<TaskModel> tasks,
  }) async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "Please sign in again!";
      }
      final taskListInMap = [];
      for(final task in tasks) {
        taskListInMap.add(task.toMap());
      }
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}task/sync'),
        headers: {
          'Content-Type': 'application/json',
          AppConstants.tokenKey: token,
        },
        body: jsonEncode(taskListInMap),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
