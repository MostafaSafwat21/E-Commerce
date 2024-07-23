import 'package:ecommerce/controllers/Auth_Controller.dart';
import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/add_to_cart_model.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final int totalAmount;

  const CheckoutPage({super.key, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthController authController = Provider.of<AuthController>(context, listen: false);
    authController.fetchUserData('uid'); // Replace with actual user ID
  }

  void submitOrder(List<AddToCartModel> cartItems) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      AuthController authController = Provider.of<AuthController>(context, listen: false);
      FirestoreDatabase firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

      final userData = authController.userData;
      final address = addressController.text.trim();
      final totalAmount = widget.totalAmount;

      firestoreDatabase.addOrder(
        OrderModel(
          id: DateTime.now().toIso8601String(),
          name: userData!.name,
          allCartItems: cartItems,
          address: address,
          totalAmount: totalAmount,
        ),
      )
          .then((value) {
        // Delete all items from cart
        for(var item in cartItems) {
          firestoreDatabase.deleteItemFromCarts(userData.uid, item.id);
        }
        Navigator.pop(context);
      })
          .catchError((error) {
        debugPrint('Error submitting order: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AuthController>(
        builder: (_, model, __) {
          final userData = model.userData;
          if (userData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<List<AddToCartModel>>(
            stream: Provider.of<FirestoreDatabase>(context).cartItems(userData.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                List<AddToCartModel> cartItems = snapshot.data ?? [];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 6.0),
                      Text(
                        'Order',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 26.0),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: userData.name,
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: '${widget.totalAmount}\$',
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: addressController,
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter your address' : null,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter your address',
                        ),
                      ),
                      const SizedBox(height: 36.0),
                      MainButton(
                        text: 'Submit Order',
                        onTap: () => submitOrder(cartItems),
                        color: Colors.blue,
                        hasCircularBorder: true,
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}
