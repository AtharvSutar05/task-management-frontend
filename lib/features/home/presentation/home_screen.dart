import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/bloc/task_cubit.dart';
import 'package:frontend/features/home/presentation/add_new_task_screen.dart';
import 'package:frontend/features/home/repositories/task_remote_repository.dart';
import '../widgets/date_selector.dart';
import '../widgets/task_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  final taskservice = TaskRemoteRepository();

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getAllTasks();
    Connectivity().onConnectivityChanged.listen((data) async {
      if(data.contains(ConnectivityResult.wifi)) {
        await context.read<TaskCubit>().syncTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Task",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewTaskScreen()),
              );
            },
            icon: Icon(Icons.add, weight: 5, size: 24),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskError) {
              return Center(child: Text(state.error));
            } else if (state is GetTasksSuccess) {
              final listOfTasks = state.tasks.where((elem) {
                final taskDate = DateTime.parse(elem.due_at);
                return taskDate.year == selectedDate.year &&
                    taskDate.month == selectedDate.month &&
                    taskDate.day == selectedDate.day;
              }).toList();

              return Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 8.0,
                children: [
                  DateSelector(
                    selectedDate: selectedDate,
                    onTap: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  ),
                  Expanded(
                    child:
                        listOfTasks.isEmpty
                            ? Center(child: Text('There is no task!'))
                            : ListView.builder(
                              itemCount: listOfTasks.length,
                              itemBuilder: (context, index) {
                                final task = listOfTasks[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TaskCard(
                                    title: task.title,
                                    description: task.description,
                                    color: task.color,
                                    due_at: task.due_at,
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
