import 'dart:convert';

import 'package:cridr/core/socket/socket_server.dart';
import 'package:cridr/core/utils/constants/api_keys.dart';
import 'package:cridr/core/utils/local_storage/storage_utility.dart';
import 'package:cridr/features/auth/presentation/pages/forget_password.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

class AuthRemoteDataSource {
  Future<void> login(String email, String password) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/auth/login");
    try {
      Response response = await post(
        uri,
        headers: {"content-type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> json = jsonDecode(response.body);
        LocalStorage().saveSecureData("token", json['token']);
        LocalStorage().saveData("role", json['role'] ? "User" : "Provider");
        LocalStorage().saveData("Id", json['id']);

        SocketServer().connect(json['token']);
        print("aaaaaaaaaaaaaa");
      } else {
        print(response.statusCode);
        throw Exception("Failed to login ${response.body}");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/auth/register");
    print("bbbbbbbbb$role");
    try {
      Response response = await post(
        uri,
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phoneNumber": phone,
          "password": password,
          "role": role == "User",
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> json = jsonDecode(response.body);
        // print(json);
        LocalStorage().saveSecureData("token", json['token']);
        debugPrint("ccccccccccc$role");
        LocalStorage().saveData("role", role);
        LocalStorage().saveData("Id", json['id']);
        SocketServer().connect(json['token']);
      } else {
        print(response.statusCode);
        throw Exception("Failed to register");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> forgetPassword(String email) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/auth/forget-password");
    try {
      Response response = await post(
        uri,
        headers: {"content-type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json['message']);
      } else {
        throw Exception("Failed to forget password");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> verifyOtp(String otp, String email) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/auth/verify-otp");
    try {
      Response response = await post(
        uri,
        headers: {"content-type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> json = jsonDecode(response.body);
        LocalStorage().saveSecureData('resetToken', json['resetToken']);
      } else {
        throw Exception("Failed to verify otp");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> resetPassword(String newPassword) async {
    Uri uri = Uri.parse("${BASE_URL}:5000/auth/reset-password");
    try {
      String resetToken =
          await LocalStorage().readSecureData('resetToken') ?? "";
      Response response = await post(
        uri,
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "resetToken": resetToken,
          "newPassword": newPassword,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> json = jsonDecode(response.body);
        print(json['message']);
      } else {
        throw Exception("Failed to reset password");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
