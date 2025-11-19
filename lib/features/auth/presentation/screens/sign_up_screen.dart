import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../home/presentation/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp() {
    if(formKey.currentState!.validate()){
      context.read<AuthCubit>().singup(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());
    }
  }

  String? _validateName(String? value) {
    if(value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegX = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if(value == null || value.trim().isEmpty) {
      return "email is required";
    } else if(!emailRegX.hasMatch(value.trim())) {
      return "email is invalid";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final lowerCase = RegExp(r'^(?=.*[a-z])');
    final specialChar = RegExp(r'^(?=.*[!@#$_&~-])');
    final number = RegExp(r'^(?=.*\d)');
    if(value == null || value.trim().isEmpty) {
      return "password is required";
    } else if(value.trim().length < 8) {
      return "password is too short";
    } else if (!lowerCase.hasMatch(value.trim())) {
      return "must contain an lowercase";
    } else if (!specialChar.hasMatch(value.trim())){
      return "password must have one special character";
    } else if(!number.hasMatch(value.trim())) {
      return "password must have numbers";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error))
            );
          }
          if(state is AuthSingUp) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if(state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: double.maxFinite,
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              bottom: 40.0,
              top: 40.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JostFont',
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: "Enter your name"),
                    validator: (value) => _validateName(value)
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "eg.example@gmail.com",
                      prefixIcon: Icon(Icons.mail)
                    ),
                    validator: (value) => _validateEmail(value)
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      hintText: "Enter the password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon:
                            isVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                      ),
                    ),
                    validator: (value) => _validatePassword(value)
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        signUp();
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Already have an account?',
                    style: TextStyle(fontFamily: 'JostFont', fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen())
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'JostFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
