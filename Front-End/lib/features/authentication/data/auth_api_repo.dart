import 'dart:convert';

import 'package:docs/features/authentication/domain/auth_repo.dart';
import 'package:docs/features/authentication/domain/user.dart';
import 'package:docs/utils/utils.dart';
import 'package:http/http.dart' as http;

class AuthApiRepo implements AuthRepo {
  //login function
  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    const String url = '${endPoint}user/login';

    final Map<String, dynamic> responseBody = {
      "email": email,
      "password": password
    };

    try {
      print('Login URL: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(responseBody),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('userData') &&
            responseData.containsKey('token')) {
          return User.fromJson({
            ...responseData['userData'],
            'token': responseData['token'],
          });
        } else {
          throw Exception('User or token data not found in response.');
        }
      } else {
        throw Exception(
            'Failed to login. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (error) {
      print('Login Error: $error');
      throw Exception('An error occurred: $error');
    }
  }

  //-------------------------------------------------------------------------------------------

  //register function
  @override
  Future<User?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    //endpoint url
    const String url = '${endPoint}user/register';

    //response body to send
    final Map<String, dynamic> requestBody = {
      "username": name,
      "email": email,
      "password": password,
    };

    //try to register
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      //check status code
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('user') &&
            responseData.containsKey('token')) {
          // Return a User with the data and token
          return User.fromJson({
            ...responseData['user'],
            'token': responseData['token'],
          });
        } else {
          throw Exception('User or token data not found in response.');
        }
      } else {
        throw Exception(
            'Failed to register. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  //-------------------------------------------------------------------------------------------

  //get user details
  @override
  Future<User?> getUserDetails(String token) async {
    //get the response
    final response = await http.get(
      Uri.parse('${endPoint}user/details'),
      headers: {
        'x-auth-token': token,
      },
    );
    //check status code
    if (response.statusCode == 200) {
      // Parse JSON response into a User objectzz
      return User.fromJson(json.decode(response.body)['user']);
    } else {
      throw Exception('Failed to load user details');
    }
  }

  //-------------------------------------------------------------------------------------------
}
