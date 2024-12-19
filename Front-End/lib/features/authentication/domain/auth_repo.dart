import 'package:docs/features/authentication/domain/user.dart';

abstract class AuthRepo {
  Future<User?> loginWithEmailAndPassword(String email, String password);
  Future<User?> registerWithEmailAndPassword(
      String name, String email, String password);
  Future<User?>getUserDetails(String token);
}
