import 'dart:convert';

class User {
  int? id;
  String username;
  String password;
  String tanggalLahir;
  String email;
  String noTelepon;
  String? foto;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.tanggalLahir,
    required this.email,
    required this.noTelepon,
    this.foto,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        tanggalLahir: json['tanggalLahir'],
        email: json['email'],
        noTelepon: json['noTelepon'],
        foto: json['foto'],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'tanggalLahir': tanggalLahir,
        'email': email,
        'noTelepon': noTelepon,
        'foto': foto,
      };
}
