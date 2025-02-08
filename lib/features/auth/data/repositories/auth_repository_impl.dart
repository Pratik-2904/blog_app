import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/core/comman/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

//we cant use intialization of auth dataSource in this this cause the dependency of impl on auth data source
//thus using dependency injection here also

class AuthRepositoryImpl implements AuthRepository {
  //constructor and dependency injection
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final currentUser = await authRemoteDataSource.getCurrentUserData();

      if (currentUser == null) {
        return left(Failure('User not logged in!'));
      }

      return right(currentUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.logInWithEmailPassword(
          email: email, password: password),
    );
    // try {
    //   final user = await authRemoteDataSource.logInWithEmailPassword(
    //       email: email, password: password);

    //   return right(user);

    // } on ServerException catch (e) {
    //   return left(Failure(e.message));
    // }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailPassword(
          email: email, name: name, password: password),
    );
    // try {
    //   //when a function uses future string use await
    //   final user = await authRemoteDataSource.signUpWithEmailPassword(
    //       email: email, name: name, password: password);
    //   //cant return userid directly on success as the fileds are not matching with the declaration
    //   //use of right in fpdart
    //   return right(user); // this means it is a success and user is its responce
    // } on ServerException catch (e) {
    //   // what this does is give type to exception of type ServerException
    //   return left(Failure(e.message));
    // }
  }

// this is used to make the above code more clean by making a common function for getting the user for login the functions
  Future<Either<Failure, User>> _getUser(
    Future<User> Function() func,
  ) async {
    try {
      final user = await func();

      return right(user);
    }

    // on adding Authexception which is the part of the supabase there is the ambiguity in the |User| so make addition of the prefix for the authExceptio
    on sb.AuthException catch (e) {
      //like this... see the imports
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
