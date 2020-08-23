import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User();
  String username;
  String email;
  QuerySnapshot savedDocs;
  String uid;

  factory User.fromJson(json, QuerySnapshot snapshot) {
    User user = User();
    user.username = json['username'];
    user.email = json['email'];
    user.savedDocs = snapshot;
    user.uid = json['uid'];
    return user;
  }
}
