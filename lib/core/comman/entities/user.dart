class User {
  final String id;
  final String name;
  final String email;

// genrate the copywith method for the user class
  // User copyWith({
  //   String? id,
  //   String? name,
  //   String? email,
  // }) {
  //   return User(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     email: email ?? this.email,
  //   );
  // }
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}

