import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/services/Auth.dart';
import 'package:ecommerce/utilities/router.dart';
import 'package:ecommerce/utilities/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/Auth_Controller.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>( create: (_) => Auth(),),
        Provider<AuthController>( create: (_) => AuthController(auth: Auth()),),
        Provider<FirestoreDatabase>(create: (_) => FirestoreDatabase('uId'),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce App',
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            primaryColor: Colors.deepOrange,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 2.0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: Theme.of(context).textTheme.titleMedium,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  )
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  )
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  )
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  )
              ),
            )
        ),
        onGenerateRoute: onGenerate,
        initialRoute: AppRoutes.landingPageRoute,
      ),
    );
  }
}
