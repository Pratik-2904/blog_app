import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

//we cant use intialization of auth dataSource in this this cause the dependency of impl on auth data source
//thus using dependency injection here also
class AuthRepositoryImpl implements AuthRepository {
  //conmstructor and dependency injection
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      //when a function uses future string use await
      final userId = await authRemoteDataSource.signUpWithEmailPassword(
          name: name, email: email, password: password);
      //cant return userid directly on success as the fileds are not matching with the declaration
      //use of right in fpdart
      return right(userId); // this means it is a success and userid is its responce
    }
    // For specific exeption
    on ServerException catch (e) {
      // what this does is give type to exception of type ServerException
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> logInWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }
}
