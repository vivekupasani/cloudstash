import 'package:bloc/bloc.dart';
import 'package:cloudstash/features/auth/domain/auth_repo.dart';
import 'package:cloudstash/features/auth/domain/user.dart';
import 'package:cloudstash/features/storage/domain/storage_repo.dart';
import 'package:flutter/material.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepo authRepo;
  StorageRepo storageRepo;
  User? _currentuser;
  AuthCubit(this.authRepo, this.storageRepo) : super(AuthInitial());

  // Check if the user is authenticated
  void checkAuth() async {
    emit(AuthLoading());
    try {
      final token = await storageRepo.getToken(
        "x-auth-token",
      ); // Await the Future
      if (token == null) {
        emit(Unauthenticated());
        return;
      }
      final user = await authRepo.getUser(token);
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      _currentuser = user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  //Sign in with email and password
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.login(email, password);
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      _currentuser = user;

      storageRepo.setToken("x-auth-token", user.token!);

      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  //Sign up with username, email and password
  Future<void> signUp(String username, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.register(username, email, password);
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      _currentuser = user;

      storageRepo.setToken("x-auth-token", user.token!);

      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  //Sign out the user
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await storageRepo.removeToken("x-auth-token");
      _currentuser = null;
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  //Update the user profile
  Future<void> updateUser(
    String username,
    String profession,
    String about,
  ) async {
    emit(AuthLoading());
    try {
      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(Unauthenticated());
        return;
      }
      final user = await authRepo.updateUser(
        username,
        profession,
        about,
        token,
      );
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      _currentuser = user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  //Change the user password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(AuthLoading());
    try {
      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(Unauthenticated());
        return;
      }
      final user = await authRepo.changePassword(
        oldPassword,
        newPassword,
        token,
      );
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      _currentuser = user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  //Get the user profile
  Future<void> getUserProfile() async {
    emit(AuthLoading());
    try {
      final token = await storageRepo.getToken("x-auth-token");
      if (token == null) {
        emit(Unauthenticated());
        return;
      }
      final user = await authRepo.getUser(token);
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      _currentuser = user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Get the current user
  User? get currentuser => _currentuser;
}
