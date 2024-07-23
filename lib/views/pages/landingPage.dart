import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/controllers/Auth_Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authPage.dart';
import 'bottomNavbar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return ChangeNotifierProvider<AuthController>(
                create: (_) => AuthController(auth: auth),
                child: const AuthPage(),
              );
            }
            else{
              return ChangeNotifierProvider<AuthController>(
                create: (_) => AuthController(auth: auth),
                child: Provider <Database>(
                  create: (_) => FirestoreDatabase(user.uid),
                  child: const BottomNavBar(),
                ),
              );
            }
          }
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        });
  }
}
