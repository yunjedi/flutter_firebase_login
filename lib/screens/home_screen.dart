import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/blocs/authentication_bloc.dart';
import 'package:login_bloc/events/authentication_event.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: (){
                  BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedOut());
                },
              )
        ],
      ),
      body: Center(
        child: Text('This is home screen',style: TextStyle(fontSize: 22),),
      ),
    );
  }
  
}