// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String bio;
    String email;
    int followers;
    int followings;
    String username;
    List<dynamic> allFollowers;
    List<dynamic> allFollowings;

    UserModel({
        required this.bio,
        required this.email,
        required this.followers,
        required this.followings,
        required this.username,
        required this.allFollowers,
        required this.allFollowings,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        bio: json["bio"],
        email: json["email"],
        followers: json["followers"],
        followings: json["followings"],
        username: json["username"],
        allFollowers: List<dynamic>.from(json["allFollowers"].map((x) => x)),
        allFollowings: List<dynamic>.from(json["allFollowings"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "bio": bio,
        "email": email,
        "followers": followers,
        "followings": followings,
        "username": username,
        "allFollowers": List<dynamic>.from(allFollowers.map((x) => x)),
        "allFollowings": List<dynamic>.from(allFollowings.map((x) => x)),
    };
}

