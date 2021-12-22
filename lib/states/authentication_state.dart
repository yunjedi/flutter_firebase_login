import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  // TODO: implement props
  List<Object> get props => []; //detect differences between two states
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final FirebaseUser firebaseUser;
  const AuthenticationSuccess({required this.firebaseUser});
  @override
  List<Object> get props => [firebaseUser];
  @override
  String toString() => 'Authentication success, email: ${firebaseUser.email}';
}

class AuthenticationFailure extends AuthenticationState {}
