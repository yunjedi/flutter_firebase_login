import 'package:flutter/cupertino.dart';

@immutable
class LoginState {
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  bool get isValidEmailAndPassword => isValidEmail && isValidPassword; //getter
  //constructor
  LoginState(
      {required this.isValidEmail,
      required this.isValidPassword,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure});
  //each state is an object, or static object,
  //Can be create by using static/factory method
  factory LoginState.initial() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }
  // loading state
  factory LoginState.loading() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }
  // failure state
  factory LoginState.failure() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: true);
  }
  // success state
  factory LoginState.success() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: true,
        isFailure: false);
  }
  //Clone an object of LoginState
  LoginState cloneWith(
      {bool? isValidEmail,
      bool? isValidPassword,
      bool? isSubmitting,
      bool? isSuccess,
      bool? isFailure}) {
    return LoginState(
        isValidEmail: isValidEmail ?? this.isValidEmail,
        isValidPassword: isValidPassword ?? this.isValidPassword,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  //Clone an object and update that object
  LoginState cloneAndUpdate({
    bool? isValidEmail,
    bool? isValidPassword,
    }) {
    return cloneWith(
        isValidEmail: isValidEmail ?? this.isValidEmail,
        isValidPassword: isValidPassword ?? this.isValidPassword,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }
}
