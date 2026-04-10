import 'package:cridr/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:cridr/features/auth/data/repository/auth_repository_imp.dart';
import 'package:cridr/features/auth/domain/repository/auth_repository.dart';
import 'package:cridr/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthCubitInitial());
  AuthRepository authRepository = AuthRepositoryImp(AuthRemoteDataSource());

  void login(String email, String password) {
    emit(AuthCubitLoading());

    authRepository
        .login(email, password)
        .then((value) => emit(authLoginSuccess()))
        .catchError((error) {
          emit(AuthCubitError(error.toString()));
        });
  }

  void register(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) async {
    emit(AuthCubitLoading());
    print("bbbbbbbbb$role");
    try {
      await authRepository.register(name, email, phone, password, role);
      emit(authRegisterSuccess());
    } catch (e) {
      emit(AuthCubitError(e.toString()));
    }
  }

  void forgetPassword(String email) {
    emit(AuthCubitLoading());

    authRepository
        .forgetPassword(email)
        .then((value) => emit(AuthForgetPasswordSuccess()))
        .catchError((error) {
          emit(AuthCubitError(error.toString()));
        });
  }

  void verifyOtp(String otp, String email) {
    emit(AuthCubitLoading());

    authRepository
        .verifyOtp(otp, email)
        .then((value) => emit(AuthVerifyOtpSuccess()))
        .catchError((error) {
          emit(AuthCubitError(error.toString()));
        });
  }

  void resetPassword(String password) {
    emit(AuthCubitLoading());

    authRepository
        .resetPassword(password)
        .then((value) => emit(AuthResetPasswordSuccess()))
        .catchError((error) {
          emit(AuthCubitError(error.toString()));
        });
  }
}
