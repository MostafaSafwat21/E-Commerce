import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/add_to_favorite_model.dart';
import 'package:ecommerce/views/widgets/favorite_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}
class _FavoritePageState extends State<FavoritePage> {

  Future<void> deleteItemFromfavorite(AddToFavoriteModel product) async {
    final database = Provider.of<Database>(context, listen: false);
    await database.deleteItemFromFavorite(product);
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder<List<AddToFavoriteModel>>(
          stream: database.myFavoriteCart(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final favoriteItem = snapshot.data ?? [];
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
                        'Favorites',
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
                      if (favoriteItem.isEmpty)
                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Favorite is empty',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (favoriteItem.isNotEmpty)
                        ListView.builder(
                          itemBuilder: (BuildContext context, int i) =>
                              FavoriteListItem(
                                favoriteItem: favoriteItem[i],
                                onDelete: deleteItemFromfavorite,
                              ),
                          itemCount: favoriteItem.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      const SizedBox(height: 16.0),
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
