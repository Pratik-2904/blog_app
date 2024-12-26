//always create the interface
//if i want to shift from supabase to any other base i could have strinct contract to follow
// dont use external plugins and the external dependencies for this.
//This is only made for handling calls to the supabase which should be seamless

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/usermodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<Usermodel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Usermodel> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // we are taking supace client via supabase Constructor
  // why we are taking client as constructor parameter and not the initilization inside the class
  // reson is this will cause the dependency between AuthRemoteDatasourceImpl and SupabaseClient.
  // So when we need to change the supabase to firebase there are many things to do and be more complex,
  //also its better for testing
  // thus we are using dependency injection instead

  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  //gives user id
  @override
  Future<Usermodel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // as function is future use await to get responce and store in responce var
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        //key value pair
        'name': name,
      });
      //session contins multiple things like id which is auto generated by supabase
      // return responce.session!.user.id;
      if (response.user == null) {
        throw ServerException(
            'User is Null!'); // can pass exceptioon calss or string but were gonna create our own excetion class
      }
      // return responce.user!.id; // if the user is null its gonna throw an exception

      //  return Usermodel(
      //     id: response.user!.id,      // This is insufficient as there is no way to access the name from the response and also its not reusably efficient
      //     name: name,                // thus we are gonna use the data from the response in json map
      //     email: response.user!.email!,
      //   );

      return Usermodel.fromJson(response.user!
          .toJson()); // this is the efficient way to do it // thus to do it we're gonna make the function for conversion in the model class
    } catch (e) {
      //any other exception occurs
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Usermodel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      if (response.user == null) {
        throw ServerException('User is Null!');
      }

      return Usermodel.fromJson(response.user!.toJson());
      
    } on ServerException catch (e) {
      throw ServerException(e.message);
    }
  }
}
