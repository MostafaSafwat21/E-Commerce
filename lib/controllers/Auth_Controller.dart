import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/user_data.dart';
import 'package:ecommerce/services/Auth.dart';
import 'package:ecommerce/utilities/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  String name;
  AuthFormType authFormType;
  final database = FirestoreDatabase('123');

  AuthController({
    required this.auth,
    this.email = '',
    this.password = '',
    this.name = '',
    this.authFormType = AuthFormType.login,
  });

  void updateEmail(String email) => copyWith(email: email);

  void updatePassword(String password) => copyWith(password: password);

  void updateName(String name) => copyWith(name: name);

  void copyWith({
    String? email,
    String? password,
    String? name,
    AuthFormType? authFormType,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.name = name ?? this.name;
    this.authFormType = authFormType ?? this.authFormType;
    notifyListeners();
  }

  void toggleFormType() {
    final formType = authFormType == AuthFormType.login
        ? AuthFormType.register
        : AuthFormType.login;

    copyWith(
      authFormType: formType,
      email: '',
      password: '',
      name: '',
    );
  }

  Future<void> submit() async {
    try {
      if (authFormType == AuthFormType.login) {
        await auth.loginWithEmailAndPassword(email, password);
      } else {
        final User? user = await auth.signUpWithEmailAndPassword(email, password);

        if (user != null) {
          await database.setUserData(UserData(
            uid: user.uid,
            email: email,
            name: name,
            isAdmin: false,
          ));
        } else {
          print('Error: User is null after sign-up.');
        }
      }
    } catch (e) {
      print('Error during submit: $e');
      rethrow;
    }
  }
  Future<void> logout() async {
    try {
      await auth.logout();
    } catch (e) {
      rethrow;
    }
  }

  UserData? _userData;

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user').doc(auth.currentUser?.uid).get();
      _userData = UserData.fromFirestore(doc);
      notifyListeners(); // Make sure to notify listeners here
    } catch (e) {
      rethrow;
    }
  }

  UserData? get userData => _userData;
}
