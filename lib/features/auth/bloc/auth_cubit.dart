import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/features/auth/repositories/auth_local_repository.dart';
import 'package:frontend/features/auth/repositories/auth_remote_repositories.dart';

part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authRemoteRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final response = await authRemoteRepository.getUserData();
      if(response == null) {
        emit(AuthInitial());
      } else {
        await authLocalRepository.insertUser(response);
        emit(AuthLoggedIn(response));
      }
    } catch(e) {
      emit(AuthInitial());
    }
  }

  void singup(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final authResponse = await authRemoteRepository.signUp(name, email, password);
      await spService.setToken(authResponse.token);
      await authLocalRepository.insertUser(authResponse.user);
      emit(AuthSingUp());
    } catch(e) {
      emit(AuthError(e.toString()));
    }
  }

  void login(String email, String password) async {
    try {
      emit(AuthLoading());
      final authResponse = await authRemoteRepository.logIn(email, password);
      await spService.setToken(authResponse.token);
      await authLocalRepository.insertUser(authResponse.user);
      emit(AuthLoggedIn(authResponse.user));
    } catch(e) {
      emit(AuthError(e.toString()));
    }
  }

}
