import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/blocs/register_bloc.dart';
import 'package:login_bloc/repositories/user_repository.dart';
import 'package:login_bloc/screens/register_screen.dart';

class RegisterUserButton extends StatelessWidget {
  final UserRepository _userRepository;
  //constructor
  RegisterUserButton({ Key? key, required UserRepository userRepository}):
        assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      child: FlatButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Text('Register a new account', style: TextStyle(color: Colors.white, fontSize: 16),),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context){
              return BlocProvider<RegisterBloc>(
                create: (context)=>RegisterBloc(userRepository: _userRepository),
                child: RegisterScreen(userRepository: _userRepository,),
              );
            })
          );
        },
      ),
    );
  }

}