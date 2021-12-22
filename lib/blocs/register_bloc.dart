import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/events/register_event.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/states/register_state.dart';
import 'package:login_bloc/validators/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _userRepository;
  //constructor
  RegisterBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> registerEvents,
      TransitionFunction<RegisterEvent, RegisterState> transitionFn) {
    final debounceStream = registerEvents.where((registerEvent) {
      return (registerEvent is RegisterEmailChanged ||
          registerEvent is RegisterPasswordChanged);
    }).debounceTime(
        Duration(microseconds: 300)); // minimum 300 ms for each event
    final nonDebounceStream = registerEvents.where((registerEvent) {
      return (registerEvent is! RegisterEmailChanged &&
          registerEvent is! RegisterPasswordChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    final registerState = state;
    if (registerEvent is RegisterEmailChanged) {
      yield registerState.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(registerEvent.email));
    } else if (registerEvent is RegisterPasswordChanged) {
      yield registerState.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(registerEvent.password));
    } else if (registerEvent is RegisterWithEmailAndPasswordPressed) {
      yield RegisterState.loading();
      try {
        await _userRepository.createUserWithEmailAndPassword(
            registerEvent.email,
            registerEvent.password
        );
        yield RegisterState.success();
      } catch (_) {
        yield RegisterState.failure();
      }
    }
  }
}
