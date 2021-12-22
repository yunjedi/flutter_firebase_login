import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/events/login_event.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/states/login_state.dart';
import 'package:login_bloc/validators/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  //constructor
  LoginBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> loginEvents,
      TransitionFunction<LoginEvent, LoginState> transitionFn) {
    final debounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is LoginEmailChanged ||
          loginEvent is LoginPasswordChanged);
    }).debounceTime(
        Duration(microseconds: 300)); // minimum 300 ms for each event
    final nonDebounceStream = loginEvents.where((loginEvent) {
      return (loginEvent is! LoginEmailChanged &&
          loginEvent is! LoginPasswordChanged);
    });
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    final loginState = state;
    if (loginEvent is LoginEmailChanged) {
      yield loginState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(loginEvent.email));
    } else if (loginEvent is LoginPasswordChanged) {
      yield loginState.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(loginEvent.password));
    } else if (loginEvent is LoginWithGooglePressed) {
      try {
        await _userRepository.signInWithGoogle();
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    } else if (loginEvent is LoginWithEmailAndPasswordPressed) {
      try {
        await _userRepository.signInWithEmailAndPassword(
            loginEvent.email, loginEvent.password);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
