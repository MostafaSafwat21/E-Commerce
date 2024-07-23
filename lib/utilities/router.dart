import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utilities/routes.dart';
import 'package:ecommerce/views/pages/bottomNavbar.dart';
import 'package:ecommerce/views/pages/landingPage.dart';
import 'package:ecommerce/views/pages/authPage.dart';
import 'package:ecommerce/views/pages/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch(settings.name){
    case AppRoutes.authPageRoute:
      return CupertinoPageRoute(
        builder: (_) => const AuthPage(),
        settings: settings,
      );

    case AppRoutes.bottomNavBarRoute:
      return CupertinoPageRoute(
        builder: (_) => const BottomNavBar(),
        settings: settings,
      );

    case AppRoutes.productDetailsPageRoute:
      final args = settings.arguments as Map<String, dynamic>;
      final product = args['product'];
      final database = args['database'];
      return CupertinoPageRoute(
        builder: (_) => Provider<Database>.value(
          value: database,
          child: ProductsDetails(product: product),
        ),
        settings: settings,
      );

    case AppRoutes.landingPageRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => const LandingPage(),
        settings: settings,
      );
  }
}