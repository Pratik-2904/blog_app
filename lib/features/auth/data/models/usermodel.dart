import 'package:blog_app/features/auth/domain/entities/user.dart';

class Usermodel extends User {
  Usermodel({
    required super.id,
    required super.name,
    required super.email}
    );

    //another way to do it would be to user super and required in the constructor saperately
    // //inefficient way of doing it
    // Usermodel({
    //   required String id,
    //   required String name,
    //   required String email
    // }) : super(id: id, name: name, email: email);


// this is the efficient way to handle data from datasource by making your own data model and defining the data conversion function into the same to have reusable and
// clean code
    factory Usermodel.fromJson(Map<String, dynamic> json) {
      return Usermodel(
        id: json['id'] ?? 'Not Found',
        name: json['name'] ?? 'Not Found',
        email: json['email'] ?? 'Not Found',
      );
    }
}

