import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    return {
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'bio': bio,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final userData = doc.data() as Map<String, dynamic>;
    // if (userData == null) {return null;}
      // final data = doc.data();
    return User(
      id: doc.id,
      username: userData['username'] ?? '',
      email: userData['email'] ?? '',
      profileImageUrl: userData['profileImageUrl'] ?? '',
      followers: (userData['followers'] ?? 0).toInt(),
      following: (userData['following'] ?? 0).toInt(),
      bio: userData['bio'] ?? '',
    );
  }
  

  Map<String, dynamic> toMap() {
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

  factory User.fromMap(Map<String, dynamic> map) {
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

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
