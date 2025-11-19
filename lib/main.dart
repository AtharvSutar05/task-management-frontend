import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/auth/bloc/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:frontend/features/home/bloc/task_cubit.dart';
import 'features/home/presentation/home_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => TaskCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppConstants.themeData,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            return const MyHomePage();
          }
          return const SignUpScreen();
        },
      ),
    );
  }
}

