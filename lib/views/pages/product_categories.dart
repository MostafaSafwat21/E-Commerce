import 'package:ecommerce/controllers/Database_Controller.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/views/widgets/product_category_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCategories extends StatefulWidget {
  const ProductCategories({super.key});

  @override
  _ProductCategoriesState createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final dataBase = Provider.of<Database>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Catergory : ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: <String>['All', 'Electronics', 'Clothes', 'Accessories', 'Others']
                      .map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _selectedCategory == 'All'
                  ? dataBase.newProductsStream()
                  : dataBase.productsByCategoryStream(_selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final products = snapshot.data;
                  if (products == null || products.isEmpty) {
                    return const Center(
                      child: Text('No Products Found!'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 20.0, // Adjust the height as needed
                          ),
                        ),
                        SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                            childAspectRatio: 0.66,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, int i) {
                              if (i == products.length) {
                                return const SizedBox(
                                  height: 60.0, // Adjust the height as needed
                                );
                              }
                              return ProductCategoryListItem(
                                product: products[i],
                                isNew: true,
                              );
                            },
                            childCount: products.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 30.0, // Adjust the height as needed
                          ),
                        ),

                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}