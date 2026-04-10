import 'package:cridr/features/auth/presentation/pages/forget_password.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String name,String email,String phone, String password,String role);
  Future<void> forgetPassword(String email);
  Future<void> verifyOtp(String otp, String email);
  Future<void> resetPassword(String password);


}