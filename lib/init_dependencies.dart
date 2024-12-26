import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance; // initialization of getit

//saperate functions for saperate dependency intialization

Future<void> initDependencies() async {
  _initAuth();
  // made future void because need to add the supabase intialization in it
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonKey);

  serviceLocator.registerLazySingleton(() => supabase.client); // used whena single object needs to be used not the new everytime
}

// this is private for this file only and not accessible out of this
void _initAuth() {
  serviceLocator
      .registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
            // new instance every single time when needed
            serviceLocator(), // this will automatically get the client form the servicelocator
            //according to the params and selects the object of the same type
          ));

  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        //the rype can also be specified
        serviceLocator(), // automatically gets the Auth remote datasource
      ));

  serviceLocator.registerFactory(() => UserSignUp(
        serviceLocator(),
      ));

  //fot the block
  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
      ));
}
