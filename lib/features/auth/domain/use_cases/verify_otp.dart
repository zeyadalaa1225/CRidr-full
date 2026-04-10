import 'package:cridr/features/auth/domain/repository/auth_repository.dart';

class VerifyOtp {
  final AuthRepository authRepository;
  VerifyOtp(this.authRepository);
  Future<void> call(String otp, String email) {
    return authRepository.verifyOtp(otp, email);
  }
}