import 'package:cridr/features/auth/domain/repository/auth_repository.dart';

class ResetPassword {
  final AuthRepository authRepository;
  ResetPassword(this.authRepository);
  Future<void> call(String password, String email) =>
      authRepository.resetPassword(password);
}
