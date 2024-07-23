import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductCategoryListItem extends StatelessWidget {
  final Product product;
  final bool isNew;
  final VoidCallback? addToFavorites;

  const ProductCategoryListItem({
    super.key,
    required this.product,
    required this.isNew,
    this.addToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = Provider.of<Database>(context);
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
        AppRoutes.productDetailsPageRoute,
        arguments: {
          'product': product,
          'database': database
        },
      ),
      child: Card(
          color: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: size.width * 0.48,
                  height: size.height * 0.22,
                  color: Colors.grey, // Set the background color to grey
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    product.imageUrl,
                    width: size.width * 0.48,
                    height: size.height * 0.22,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0,
                  ),
                  child: SizedBox(
                    width: 50,
                    height: 25,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: product.discountValue == 0 ? Colors.black : Colors.red,                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text(
                            product.discountValue == 0 ? 'NEW' : '${product.discountValue}%',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        itemSize: 23.0,
                        rating: product.rate?.toDouble() ?? 0.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        product.rate != null ? '${(product.rate! * 20)}%' : '0%',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Text(
                        product.title,
                        style:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(product.discountValue != 0)
                            Text(
                            '${product.price}\$',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${product.price * (100-product.discountValue) / 100}\$',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
