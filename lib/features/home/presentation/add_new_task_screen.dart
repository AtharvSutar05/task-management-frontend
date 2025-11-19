import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_cubit.dart';
import 'package:frontend/features/home/bloc/task_cubit.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime initialTime = DateTime.now();
  DateTime finalTime = DateTime.now().add(Duration(days: 5));
  Color defaultColor = Colors.black12;
  final formKey = GlobalKey<FormState>();

  void createTask() async {
    if (formKey.currentState!.validate()) {

      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;

      await context.read<TaskCubit>().createTask(
        uid: user.user.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        color: defaultColor,
        due_at: initialTime,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add new Task",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AddNewTaskSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Task added!")));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${DateFormat("MM-d-y").format(initialTime)} - ${DateFormat('MM-d-y').format(finalTime)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selectedTime = await showDatePicker(
                              context: context,
                              firstDate: initialTime,
                              lastDate: finalTime,
                            );
                            setState(() {
                              if (selectedTime != null) {
                                initialTime = selectedTime;
                              }
                            });
                          },
                          icon: Icon(Icons.edit, size: 20),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Title"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title cannot be empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(hintText: "Description"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description cannot be empty";
                      }
                      return null;
                    },
                  ),
                  ColorPicker(
                    color: defaultColor,
                    onColorChanged: (color) {
                      setState(() {
                        defaultColor = color;
                      });
                    },
                    pickersEnabled: const {ColorPickerType.wheel: true},
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        createTask();
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
