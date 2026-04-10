import 'package:cridr/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:cridr/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImp extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImp(this.authRemoteDataSource);

  @override
  Future<void> login(String email, String password) =>
      authRemoteDataSource.login(email, password);

  @override
  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) => authRemoteDataSource.register(name, email, phone, password, role);

  @override
  Future<void> forgetPassword(String email) =>
      authRemoteDataSource.forgetPassword(email);

  @override
  Future<void> verifyOtp(String otp, String email) =>
      authRemoteDataSource.verifyOtp(otp, email);

  @override
  Future<void> resetPassword(String password) =>
      authRemoteDataSource.resetPassword(password);
}
