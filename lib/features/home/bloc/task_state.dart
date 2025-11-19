part of 'task_cubit.dart';
sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState{}
final class TaskLoading extends TaskState{}
final class TaskError extends TaskState{
  final String error;
  const TaskError(this.error);
}
final class AddNewTaskSuccess extends TaskState{
  final TaskModel taskModel;
  const AddNewTaskSuccess(this.taskModel);
}

final class GetTasksSuccess extends TaskState {
  final List<TaskModel> tasks;
  GetTasksSuccess(this.tasks);
}