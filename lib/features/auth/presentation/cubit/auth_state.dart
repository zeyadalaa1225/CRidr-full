abstract class AuthState {}

class AuthCubitInitial extends AuthState {}

class AuthCubitLoading extends AuthState {}

class authLoginSuccess extends AuthState {}

class authRegisterSuccess extends AuthState {}

class AuthForgetPasswordSuccess extends AuthState {}

class AuthVerifyOtpSuccess extends AuthState {}

class AuthResetPasswordSuccess extends AuthState {}

class AuthCubitError extends AuthState {
  String errorMessage;

  AuthCubitError(this.errorMessage);
}
