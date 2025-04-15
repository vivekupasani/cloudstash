import 'package:cloudstash/features/auth/domain/user.dart';

abstract class AuthRepo {
  Future<User?> login(String email, String password);
  Future<User?> register(String username, String email, String password);
  Future<User?> getUser(String token);
  Future<User?> updateUser(
    String username,
    String profession,
    String about,
    String token,
  );
  Future<User?> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  );
}
