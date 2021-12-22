import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/blocs/authentication_bloc.dart';
import 'package:login_bloc/blocs/login_bloc.dart';
import 'package:login_bloc/blocs/simple_bloc_observer.dart';
import 'package:login_bloc/events/authentication_event.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/screens/home_screen.dart';
import 'package:login_bloc/screens/login_screen.dart';
import 'package:login_bloc/screens/splash_screen.dart';
import 'package:login_bloc/states/authentication_state.dart';


void main()  {

  WidgetsFlutterBinding.ensureInitialized(); // important
  Bloc.observer = SimpleBlocObserver();
  // //test firebase login
  // final userRepository = UserRepository();
  // userRepository.createUserWithEmailAndPassword('email1@gmai.com', 'password');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Login',
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)..add(AuthenticationEventStarted()),
        // {
        //   final authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
        //   authenticationBloc.add(AuthenticationEventStarted());
        //   return authenticationBloc;
        // }
        child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder: (context,authenticationState){
            if (authenticationState is AuthenticationSuccess) {
              return HomeScreen(); // Home Page
            } else if (authenticationState is AuthenticationFailure) {
              return BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(userRepository: _userRepository),
                child: LoginScreen(userRepository: _userRepository,),
              );
            }
            return SplashScreen();
          },
        ),
      )
    );
  }
}



