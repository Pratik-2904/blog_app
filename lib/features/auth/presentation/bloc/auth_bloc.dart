// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart'; // we are depending on the flutter block not the block default so remove thesse dependencies

import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp
      _userSignUp; // make it privete or anyone would be having their hands on the userSignUp and create instance of it i.e. data leakage
  AuthBloc({
    required UserSignUp
        userSignUp, // inside the constructor initialized the userSignUp
  })  : _userSignUp = userSignUp, // set the value to _userSignUp
        // as there should be multiple useCases preffer named argument instead of this._userSignUp
        super(AuthInitial()) {
    // add the implementation to catch the userSignupEvent
    on<AuthSignUp>(
      // to get email password and name we can attach it tot the AuthSignUP From the Widgets
      (event, emit) async {
        // _userSignUp.call(params);
        // this can be done but there is a special function for the same in dart

        //returns future aitherfailure or success
        //ake the await and async
        final response = await _userSignUp(
            UserSignUpParams(event.email, event.name, event.password));
        //reponce and failure independetly

        response.fold((failure) => emit(AuthFailure(failure.message)),
            (uid) => emit(AuthSuccess(uid)));
      },
    );
  }
}