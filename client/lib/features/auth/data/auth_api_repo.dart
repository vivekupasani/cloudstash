import 'dart:convert';
import 'package:cloudstash/features/auth/domain/auth_repo.dart';
import 'package:cloudstash/features/auth/domain/user.dart';
import 'package:http/http.dart' as http;

class AuthApiRepo implements AuthRepo {
  final baseUrl = "http://localhost:3000/user";

  //changePassword method
  @override
  Future<User?> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    try {
      //Setting up variables
      final Uri url = Uri.parse("$baseUrl/change-password");
      final Map<String, dynamic> body = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };
      final headers = {
        "Content-Type": "application/json",
        "x-auth-token": token,
      };

      //hitting the API
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final decode = jsonDecode(res.body);
        return User.fromJson({...decode['user'], 'token': decode['token']});
      }
      return null;
    } catch (e) {
      throw Exception("Change password failed. $e");
    }
  }

  //getUser method
  @override
  Future<User?> getUser(String token) async {
    final Uri url = Uri.parse("$baseUrl/profile");
    final headers = {"Content-Type": "application/json", "x-auth-token": token};

    final res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      final decode = jsonDecode(res.body);
      return User.fromJson(decode['user']);
    } else {
      throw Exception("Failed to fetch user data. ${res.statusCode}");
    }
  }

  //login method
  @override
  Future<User?> login(String email, String password) async {
    try {
      //Setting up variables
      final Uri url = Uri.parse("$baseUrl/login");
      final Map<String, dynamic> body = {"email": email, "password": password};
      final headers = {"Content-Type": "application/json"};

      //hitting the API
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      //Checking the response
      if (res.statusCode == 200) {
        //Parsing the response
        final decode = jsonDecode(res.body);

        //Returning the user object
        return User.fromJson({...decode['user'], 'token': decode['token']});
      }
      return null;
    } catch (e) {
      throw Exception("Login failed. $e");
    }
  }

  //register method
  @override
  Future<User?> register(String username, String email, String password) async {
    try {
      //Setting up variables
      final Uri url = Uri.parse("$baseUrl/register");
      final Map<String, dynamic> body = {
        "username": username,
        "email": email,
        "password": password,
        "proffession": "Cloudstash User",
        "about":
            "I'am a Cloudstash user. I am using this app to store my files.",
      };
      final headers = {"Content-Type": "application/json"};

      //hitting the API
      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      //Checking the response
      if (res.statusCode == 200) {
        //Parsing the response
        final decode = jsonDecode(res.body);

        //Returning the user object
        return User.fromJson({...decode['user'], 'token': decode['token']});
      }
      return null;
    } catch (e) {
      throw Exception("Register failed. $e");
    }
  }

  //updateUser method
  @override
  Future<User?> updateUser(
    String username,
    String profession,
    String about,
    String token,
  ) async {
    try {
      //Setting up variables
      final Uri url = Uri.parse("$baseUrl/update-profile");
      final Map<String, dynamic> body = {
        "username": username,
        "proffession": profession,
        "about": about,
      };
      final headers = {
        "Content-Type": "application/json",
        "x-auth-token": token,
      };

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final decode = jsonDecode(res.body);
        return User.fromJson(decode['user']);
      }
      return null;
    } catch (e) {
      throw Exception("Update user failed. $e");
    }
  }
}
