import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> loginWithEmailAndPassword(String email, String password);

  Future<User?> signUpWithEmailAndPassword(String email, String password,);

  Future<void> logout();
}

class Auth implements AuthBase {
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    final userAuth = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userAuth.user;
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    final userAuth = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userAuth.user;
  }

  @override
  User? get currentUser => firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => firebaseAuth.authStateChanges();

  @override
  Future<void> logout() async => await firebaseAuth.signOut();
}