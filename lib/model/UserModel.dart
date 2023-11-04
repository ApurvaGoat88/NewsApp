// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String bio;
  String email;
  String uid;
  String username;

  UserModel({
    required this.bio,
    required this.email,
    required this.username,
    required this.uid ,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        bio: json["bio"],
        email: json["email"],
        username: json["username"],
        uid: json['uid']
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "email": email,
        "username": username,
        "uid":uid
      };
}
