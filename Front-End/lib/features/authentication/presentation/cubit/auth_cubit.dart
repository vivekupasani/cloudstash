import 'package:bloc/bloc.dart';
import 'package:docs/features/authentication/domain/auth_repo.dart';
import 'package:docs/features/authentication/domain/user.dart';
import 'package:docs/features/storage/domain/storage_repo.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  //repos
  final AuthRepo authRepo;
  final StorageRepo storageRepo;
  //current user to track user
  User? _currentUser;
  AuthCubit(this.authRepo, this.storageRepo) : super(AuthInitial());

  //-------------------------------------------------------------------------------------------

  //login
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      //emit the loading state
      emit(AuthLoading());

      //try to login
      final user = await authRepo.loginWithEmailAndPassword(email, password);

      //check user is not null
      if (user != null) {
        _currentUser = user;
        //store token in shared preferences
        storageRepo.storeToken(user.token);
        print("User TOKEN${user.token}");
        print("User ID${user.id}");
        print("User EMAIL${user.email}");
        print("User USERNAME${user.username}");
        //emit the authenticated state
        emit(Authenticated(user));
      } else {
        //emit unauthenticated state
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  //-------------------------------------------------------------------------------------------

  User? get currentuser => _currentUser;

  //-------------------------------------------------------------------------------------------

  //register
  Future<void> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      //emit loading state
      emit(AuthLoading());

      //try to register
      final user =
          await authRepo.registerWithEmailAndPassword(name, email, password);

      //check user is not null
      if (user != null) {
        _currentUser = user;

        //store token in shared preferences
        storageRepo.storeToken(user.token);
        print("User TOKEN${user.token}");
        print("User ID${user.id}");
        print("User EMAIL${user.email}");
        print("User USERNAME${user.username}");

        //emit the authenticated state
        emit(Authenticated(user));
      } else {
        //emit unauthenticated state
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  //-------------------------------------------------------------------------------------------

  //sign out
  Future<void> signOut() async {
    try {
      // Attempt to delete the stored token from storage (local or secure storage)
      await storageRepo.deleteToken();

      // Set the current user to null to indicate the user is logged out
      _currentUser = null;

      // Emit an 'Unauthenticated' state to update the UI or the app flow
      emit(Unauthenticated());
    } catch (e) {
      // Catch any errors that occur during the sign-out process
      // Emit an 'AuthError' state with the error message
      emit(AuthError(message: e.toString()));

      // Optionally, log the error for debugging purposes
      print('Error signing out: $e');
    }
  }

  //-------------------------------------------------------------------------------------------

//check state persistance
  Future<void> checkAuth() async {
    // Get the token
    final token = await storageRepo.getToken();

    if (kDebugMode) {
      print("TOKEN: $token");
    }

    // Check token here
    if (token != null && token.isNotEmpty && token != 'EMPTY') {
      // Get user details using token
      try {
        final user = await authRepo.getUserDetails(token);
        _currentUser = user;

        if (kDebugMode) {
          print("CURRENT USER: ${_currentUser!.email}");
          print("CURRENT USER: ${_currentUser!.id}");
          print("CURRENT USER: ${_currentUser!.username}");
        }
        // Ensure the state is emitted properly
        emit(Authenticated(user!)); // Emitting authenticated state
      } catch (e) {
        print('Error fetching user details: $e');

        // Handle token-related errors (expired, invalid, etc.)
        if (e.toString().contains('TokenExpiredError')) {
          // Handle token expiration (e.g., force logout or re-login)
          print('Token has expired, please log in again.');
        }

        // Emit Unauthenticated if any error occurs
        emit(Unauthenticated());
      }
    } else {
      // Emit Unauthenticated if no token found
      emit(Unauthenticated());
    }
  }

  //-------------------------------------------------------------------------------------------
}
