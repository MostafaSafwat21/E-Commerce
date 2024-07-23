import 'package:flutter/material.dart';
import 'package:ecommerce/controllers/Auth_Controller.dart';
import 'package:ecommerce/views/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'add_product_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    AuthController authController = Provider.of<AuthController>(context, listen: false);
    authController.fetchUserData('uid'); // Replace with actual user ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthController>(
        builder: (_, model, __) {
          final userData = model.userData;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if(userData?.isAdmin == true)
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: MainButton(
                      color: Colors.cyan,
                      text: 'Add Product',
                      onTap: () => _navigateToAddProduct(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15),
                    child: MainButton(
                      color: Colors.black45,
                      text: 'Log Out',
                      onTap: () => _logout(model, context),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  Future<void> _logout(AuthController model, BuildContext context) async {
    try {
      await model.logout();
      Navigator.pop(context);
    } catch (e) {
      debugPrint('logout error: $e');
    }
  }
}

