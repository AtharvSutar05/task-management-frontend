import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils.dart';
import 'package:frontend/data/models/task_model.dart';
import 'package:frontend/features/home/repositories/task_local_repository.dart';
import 'package:frontend/features/home/repositories/task_remote_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required DateTime due_at,
    required String uid,
  }) async {
    try {
      emit(TaskLoading());
      final task = await taskRemoteRepository.createTask(
        title: title,
        description: description,
        hex_color: rgbToHex(color),
        due_at: due_at,
        uid: uid,
      );
      await taskLocalRepository.insertTask(task);
      emit(AddNewTaskSuccess(task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> getAllTasks() async {
    try {
      emit(TaskLoading());
      final tasks = await taskRemoteRepository.getTasks();
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> syncTasks() async {
    final unSyncTask = await taskLocalRepository.getUnSyncTasks();
    if(unSyncTask.isEmpty) {
      return;
    }
    final isSynced = await taskRemoteRepository.syncTasks(tasks: unSyncTask);
    if(isSynced) {
      for(final task in unSyncTask) {
        await taskLocalRepository.updateUnSyncTasks(task.id, 1);
      }
    }
  }

}
