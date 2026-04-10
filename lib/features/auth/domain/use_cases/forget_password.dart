import 'package:cridr/features/auth/domain/repository/auth_repository.dart';

class ForgetPassword {
  final AuthRepository repository;
  ForgetPassword(this.repository);
  Future<void> call(String email) {
    return repository.forgetPassword(email);
  }
}
