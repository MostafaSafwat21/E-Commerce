import 'package:ecommerce/models/add_to_favorite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavoriteListItem extends StatelessWidget {
  final AddToFavoriteModel favoriteItem;
  final Future<void> Function(AddToFavoriteModel) onDelete;

  const FavoriteListItem({super.key, required this.favoriteItem, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final price = favoriteItem.price ?? 0;
    final discountValue = favoriteItem.discountValue ?? 0;

    final discountedPrice = price * (100 - discountValue) / 100;

    return SizedBox(
      height: 150.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
              child: Image.network(
                '${favoriteItem.imageUrl}',
                width: size.width * 0.34,
                height: size.height * 0.21,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${favoriteItem.category}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          height: 26.0,
                          child: IconButton(
                            onPressed: () async {
                              await onDelete(favoriteItem);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0,),
                    Text(
                      '${favoriteItem.title}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '$discountedPrice\$',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.green.shade600,
                          ),
                        ),
                        const Spacer(),
                        RatingBarIndicator(
                          itemSize: 23.0,
                          rating: favoriteItem.rate?.toDouble() ?? 0.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}