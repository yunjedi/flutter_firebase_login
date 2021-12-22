import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  //constructor
  const RegisterEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() {
    return 'Email changed: $email';
  }
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  //constructor
  const RegisterPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() {
    return 'Password changed: $password';
  }
}

class RegisterWithEmailAndPasswordPressed extends RegisterEvent {
  final String email;
  final String password;
  const RegisterWithEmailAndPasswordPressed(
      {required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() {
    return 'RegisterWithEmailAndPasswordPressed,email: $email, password: $password';
  }
}
