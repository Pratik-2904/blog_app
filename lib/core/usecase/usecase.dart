import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccessType, Params> {
  //EveryUsecase Should Have only one function
  //usecases do only one task ans expose only one methos to the outcode

  //Sucess cannot be the String it Could be anythong in this case it could be blog thus
  //definig the Templte type

  //the parameters could be anything and any number when you talk about the genric function
  //Thus defining generic parameters
  Future<Either<Failure, SuccessType>> call(Params params); //this call function is the unique functio when its in the classes
}
