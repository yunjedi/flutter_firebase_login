import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  //constructor
  const LoginEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() {
    return 'Email changed: $email';
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  //constructor
  const LoginPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() {
    return 'Password changed: $password';
  }
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;
  const LoginWithEmailAndPasswordPressed(
      {required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() {
    return 'LoginWithEmailAndPasswordPressed,email: $email, password: $password';
  }
}
