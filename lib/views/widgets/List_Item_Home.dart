import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ListItemHome extends StatelessWidget {
  final Product product;
  final bool isNew;
  final VoidCallback? addToFavorites;
  bool isFavorite;

  ListItemHome({
    super.key,
    required this.product,
    required this.isNew,
    this.addToFavorites,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
        AppRoutes.productDetailsPageRoute,
        arguments: {
          'product': product,
          'database': database
        },
      ),
      child: Stack(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  product.imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 50,
                  height: 25,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: product.discountValue == 0 ? Colors.black : Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          product.discountValue == 0 ? 'NEW' : '${product.discountValue}%',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
          // TODO: Create one component for the favorite button
          Positioned(
            bottom: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    const SizedBox(width: 4.0),
                    Text(
                      product.rate != null ? '${(product.rate! * 20)}%' : '0%',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        if(product.discountValue != 0)
                          Text(
                            '${product.price}\$',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: size.width * 0.21,),
                        if(product.discountValue == 0)
                          SizedBox(width: size.width * 0.35,),
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
    );
  }
}