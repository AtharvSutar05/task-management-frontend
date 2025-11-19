class UserModel {
  final String id;
  final String name;
  final String email;
  final String created_at;
  final String updated_at;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.created_at,
    required this.updated_at,
  });

  UserModel copyWith({String? name, String? email, String? updated_at}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      created_at: created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic>  toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'created_at': created_at,
      'updated_at': updated_at
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "created_at": created_at,
      "updated_at": updated_at,
    };
  }
}
