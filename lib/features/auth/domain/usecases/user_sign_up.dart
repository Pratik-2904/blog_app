//Use cases should have some structure to it
//there should be comfirmed set of bounds like what w are returning
//thus there is need of interface for usecase

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import "package:fpdart/fpdart.dart";

//generics are success and params
class UserSignUp implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository; // dont use implementation because we dont want to hvaed dependency on implementation but in interface
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    final response = await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
    return response;
  } //we'll first pass the generics if not the class will assusme by defalut it as dynamic
}

class UserSignUpParams {
  final String email;
  final String name;
  final String password;

  UserSignUpParams(this.email, this.name, this.password);
}
