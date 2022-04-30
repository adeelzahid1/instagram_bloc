import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final int followers;
  final int following;
  final String bio;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.bio,
  });

  static const empty = User(id: '', username: '', email: '', profileImageUrl: '', followers: 0, following: 0, bio: '');




  @override
  List<Object> get props {
    return [
      id,
      username,
      email,
      profileImageUrl,
      followers,
      following,
      bio,
    ];
  }



  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    int? followers,
    int? following,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toDocument() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'username': username});
    result.addAll({'email': email});
    result.addAll({'profileImageUrl': profileImageUrl});
    result.addAll({'followers': followers});
    result.addAll({'following': following});
    result.addAll({'bio': bio});
  
    return result;
  }

  factory User.fromDocument(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      followers: map['followers']?.toInt() ?? 0,
      following: map['following']?.toInt() ?? 0,
      bio: map['bio'] ?? '',
    );
  }

  String toJson() => json.encode(toDocument());

  factory User.fromJson(String source) => User.fromDocument(json.decode(source));
}
