import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/events/authentication_event.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/states/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  //constructor
  AuthenticationBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationInitial()); //Initial state
  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent authenticationEvent) async* {
    if (authenticationEvent is AuthenticationEventStarted) {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        // final firebaseUser = await _userRepository.getCurrentUser();
        yield AuthenticationSuccess(firebaseUser: await _userRepository.getCurrentUser());
      } else {
        yield AuthenticationFailure();
      }
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      // final firebaseUser = await _userRepository.getCurrentUser();
      yield AuthenticationSuccess(firebaseUser: await _userRepository.getCurrentUser());
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      _userRepository.signOut();
      yield AuthenticationFailure();
    }
  }
}
