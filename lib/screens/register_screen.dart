import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/blocs/authentication_bloc.dart';
import 'package:login_bloc/blocs/register_bloc.dart';
import 'package:login_bloc/events/authentication_event.dart';
import 'package:login_bloc/events/register_event.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/states/register_state.dart';

import 'buttons/register_button.dart';

class RegisterScreen extends StatefulWidget{
  final UserRepository _userRepository;
  //constructor
  RegisterScreen({ Key? key, required UserRepository userRepository}):
      assert(userRepository != null),
      _userRepository = userRepository,
      super(key: key);
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late RegisterBloc _registerBloc;
  UserRepository get _userRepository => widget._userRepository; //getter, get a value from the stateful

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(() {
      // when email is changed, this function is called!
      _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
      
    });
    _passwordController.addListener(() {
      // when password is changed, this func is called
      _registerBloc.add(RegisterPasswordChanged(password: _passwordController.text));
    });
  } //initState()
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty; //getter
  bool isRegisterButtonEnabled(RegisterState registerState){
    return registerState.isValidEmailAndPassword & isPopulated && !registerState.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RegisterBloc,RegisterState>(
        builder: (context,registerState){
          if (registerState.isFailure) {
            print('Register failed');
          } else if (registerState.isSubmitting) {
            print('Logging in');
          } else if (registerState.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedIn());
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
                        return registerState.isValidEmail ? null : 'Invalid email format';
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
                        return registerState.isValidPassword ? null : 'Invalid password format';
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: RegisterButton(
                        onPressed: (){
                          if (isRegisterButtonEnabled(registerState)) {
                            _registerBloc.add(
                              RegisterWithEmailAndPasswordPressed(
                                  email: _emailController.text,
                                  password: _passwordController.text),
                            );
                          }
                        }
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }
  void _onRegisterEmailAndPassword() {
    _registerBloc.add(RegisterWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text));

  }
}