// import 'package:bloc/bloc.dart';
import 'package:blog_app/core/comman/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/comman/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_log_in.dart';
// import 'package:meta/meta.dart'; // we are depending on the flutter block not the block default so remove thesse dependencies

import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp
      _userSignUp; // make it privete or anyone would be having their hands on the userSignUp and create instance of it i.e. data leakage
  final UserLogIn _userLogIn;

  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp
        userSignUp, // inside the constructor initialized the userSignUp
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp, // set the value to _userSignUp
        _userLogIn = userLogIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        // as there should be multiple useCases preffer named argument instead of this._userSignUp
        super(AuthInitial()) {
    
    //This provide the loading state to eachpage
    on<AuthEvent>((_,emit) => emit(AuthLoading()));
    // add the implementation to catch the userSignupEvent
    on<AuthSignUp>(_onAuthSignUp);
    // todo add the auth login blck
    on<AuthLogIn>(_onAuthLogin);

    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    // to get email password and name we can attach it tot the AuthSignUP From the Widgets
    emit(AuthLoading());
    // _userSignUp.call(params);
    // this can be done but there is a special function for the same in dart

    //returns future aitherfailure or success
    //ake the await and async
    final response = await _userSignUp(UserSignUpParams(
      event.email,
      event.name,
      event.password,
    ));
    //reponce and failure independetly

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogIn event, Emitter<AuthState> emit) async {
    
    emit(AuthLoading());

    final res = await _userLogIn(UserLogInParams(
      email: event.email,
      password: event.password,
    ));

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {

    emit(AuthLoading());
    final result = await _currentUser(NoParams());

    result.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit){
     _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
