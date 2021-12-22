import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/blocs/authentication_bloc.dart';
import 'package:login_bloc/blocs/login_bloc.dart';
import 'package:login_bloc/events/authentication_event.dart';
import 'package:login_bloc/events/login_event.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/screens/buttons/google_login_button.dart';
import 'package:login_bloc/screens/buttons/login_button.dart';
import 'package:login_bloc/screens/buttons/register_user_button.dart';
import 'package:login_bloc/states/login_state.dart';

class LoginScreen extends StatefulWidget{
  final UserRepository _userRepository;
  //constructor
  LoginScreen({ Key? key, required UserRepository userRepository}):
      assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository; //getter, get a value from the stateful

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      // when email is changed, this function is called!
      _loginBloc.add(LoginEmailChanged(email: _emailController.text));
      
    });
    _passwordController.addListener(() {
      // when password is changed, this func is called
      _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
    });
  }
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty; //getter
  bool isLoginButtonEnabled(LoginState loginState){
    return loginState.isValidEmailAndPassword & isPopulated && !loginState.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc,LoginState>(
        builder: (context,loginState){
          if (loginState.isFailure) {
            print('Login failed');
          } else if (loginState.isSubmitting) {
            print('Logging in');
            if (loginState.isSuccess) {
              print('Logged in');
              BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationEventLoggedIn());
            }
          }
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Enter your email'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_){
                        return loginState.isValidEmail ? null : 'Invalid email format';
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.password),
                        labelText: 'Enter your password'
                      ),
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return loginState.isValidPassword ? null : 'Invalid password format';
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          LoginButton(
                            onPressed: isLoginButtonEnabled(loginState) ?
                            _onLoginEmailAndPassword: null, // if isLoginButtonEnabled = true, call this func
                          ),
                          Padding(padding: EdgeInsets.only(top: 10),),
                          GoogleLoginButton(),
                          Padding(padding: EdgeInsets.only(top: 10),),
                          RegisterUserButton(userRepository: _userRepository,)
                        ],
                      )
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }
  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text));

  }
}