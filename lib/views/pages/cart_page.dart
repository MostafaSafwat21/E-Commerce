import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/add_to_cart_model.dart';
import 'package:ecommerce/views/pages/checkout_page.dart';
import 'package:ecommerce/views/widgets/cart_list_item.dart';
import 'package:ecommerce/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalAmount = 0;

  Future<void> deleteItemFromCart(AddToCartModel product) async {
    final database = Provider.of<Database>(context, listen: false);
    await database.deleteItemFromCart(product);
    setState(() {
      totalAmount -= product.price * (100-product.discountValue) ~/ 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder<List<AddToCartModel>>(
          stream: database.myProductsCart(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final cartItem = snapshot.data ?? [];
              totalAmount = cartItem.fold(0, (total, item) => total + item.price * (100 - item.discountValue) ~/ 100);
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'My Cart',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (cartItem.isEmpty)
                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Cart is empty',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (cartItem.isNotEmpty)
                        Column(
                          children: [
                            ListView.builder(
                              itemBuilder: (BuildContext context, int i) => CartListItem(
                                cartItem: cartItem[i],
                                onDelete: deleteItemFromCart,
                              ),
                              itemCount: cartItem.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total amount:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${totalAmount.toString()}\$',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            MainButton(
                              text: 'Checkout',
                              onTap: () => navigateToCheckout(context, totalAmount),
                              hasCircularBorder: true,
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
void navigateToCheckout(BuildContext context, int totalAmount) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CheckoutPage(totalAmount: totalAmount)),
  );
}
