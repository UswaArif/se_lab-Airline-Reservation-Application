import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/user_model.dart';

class UserRepository {
  static UserRepository? _instance;

  // Private constructor to prevent external instantiation
  UserRepository._();

  // Factory constructor to create or retrieve the instance
  factory UserRepository() {
    _instance ??= UserRepository._(); // Create the instance if it doesn't exist
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  void createUser(BuildContext context, UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());
      final snackBar = SnackBar(
        content: Text("Account has been created."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error creating account: $e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

UserRepository userRepository = UserRepository(); // Get an instance


