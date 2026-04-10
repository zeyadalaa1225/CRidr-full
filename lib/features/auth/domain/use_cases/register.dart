import 'package:cridr/features/auth/domain/repository/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);
  Future<void>call(String name,String email,String phone, String password,String role) {
    return repository.register(name,email,phone, password,role);
  }
}
