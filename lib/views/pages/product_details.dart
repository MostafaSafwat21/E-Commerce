import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/add_to_cart_model.dart';
import 'package:ecommerce/models/add_to_favorite_model.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utilities/constant.dart';
import 'package:ecommerce/views/widgets/drop_down_menu.dart';
import 'package:ecommerce/views/widgets/main_button.dart';
import 'package:ecommerce/views/widgets/main_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsDetails extends StatefulWidget {
  final Product product;

  const ProductsDetails({super.key, required this.product});

  @override
  State<ProductsDetails> createState() => ProductsDetailsState();
}

class ProductsDetailsState extends State<ProductsDetails> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final database = Provider.of<Database>(context, listen: false);
    isFavorite = await database.isFavorite(widget.product.id);
    setState(() {});
  }

  Future<void> addToCart(Database database) async {
    try {
      final addToCartProduct = AddToCartModel(
        id: documentIdFromLocalData(),
        title: widget.product.title,
        price: widget.product.price,
        productId: widget.product.id,
        imageUrl: widget.product.imageUrl,
        discountValue: widget.product.discountValue,
      );
      await database.addToCart(addToCartProduct);
      if (!mounted) return;
      MainDialog(context: context, title: 'Success', content: 'Added to cart')
          .showAlertDialog();
    } catch (e) {
      MainDialog(context: context, title: 'Error', content: e.toString())
          .showAlertDialog();
    }
  }

  Future<void> addToFavoriteProduct(Database database) async {
    try {
      final addToFavoriteProduct = AddToFavoriteModel(
        id: widget.product.id,
        title: widget.product.title,
        price: widget.product.price,
        imageUrl: widget.product.imageUrl,
        discountValue: widget.product.discountValue,
        category: widget.product.category,
        rate: widget.product.rate,
        isFavorite: true,
      );
      await database.addToFavorite(addToFavoriteProduct);
      if (!mounted) return;
      setState(() {
        isFavorite = true;
      });
    } catch (e) {
      MainDialog(context: context, title: 'Error', content: e.toString())
          .showAlertDialog();
    }
  }

  Future<void> deleteItemsFromdetails(List<String> productIds) async {
    final database = Provider.of<Database>(context, listen: false);
    for (String productId in productIds) {
      await database.deleteItemFromDetails(AddToFavoriteModel(id: productId));
    }
    setState(() {
      isFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = Provider.of<Database>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.product.imageUrl,
              width: double.infinity,
              height: size.height * 0.45,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (isFavorite) {
                            deleteItemsFromdetails([widget.product.id]);
                          } else {
                            addToFavoriteProduct(database);
                          }
                        },
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 28.0,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '  ${widget.product.price * (100-widget.product.discountValue) / 100}\$',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.product.category,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'This is a dummy description for this product! I think we will add it in the future! I need to add more lines, so I add these words just to have more than two lines!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24.0),
                  MainButton(
                    text: 'Add to cart',
                    onTap: () => addToCart(database),
                    hasCircularBorder: true,
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
