//interfaces are used to define the methods that class must implement
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/comman/entities/user.dart';
import 'package:fpdart/fpdart.dart';


abstract interface class AuthRepository {
//Either failure or success
// For asyncromous and data fetching from supermodel make it future

//We will success part later

  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
  
}
