import 'dart:ui';
import 'package:frontend/core/utils.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final String due_at;
  final String created_at;
  final String updated_at;
  final Color color;
  final int isSynced;

  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.due_at,
    required this.created_at,
    required this.updated_at,
    required this.color,
    required this.isSynced,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      due_at: json['due_at'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      color: hexToRgb(json['hex_color']),
      isSynced: 1
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      due_at: map['due_at'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      color: hexToRgb(map['hex_color']),
      isSynced: map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'due_at': due_at,
      'created_at': created_at,
      'updated_at': updated_at,
      'hex_color': rgbToHex(color),
      'isSynced': isSynced,
    };
  }
}
