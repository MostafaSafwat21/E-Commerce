import 'package:ecommerce/models/add_to_cart_model.dart';
import 'package:ecommerce/models/add_to_favorite_model.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/models/user_data.dart';
import 'package:ecommerce/services/firestore_services.dart';
import 'package:ecommerce/utilities/api_path.dart';
import '../models/product.dart';

abstract class Database {
  Stream<List<Product>> salesProductsStream();
  Stream<List<Product>> newProductsStream();
  Stream<List<AddToCartModel>> myProductsCart();
  Stream<List<AddToFavoriteModel>> myFavoriteCart();
  Stream<List<AddToCartModel>> cartItems(String uid); // Return a stream
  Stream<List<Product>> productsByCategoryStream(String category);

  Future<void> setUserData(UserData userData);
  Future<void> addProduct(Product product);
  Future<void> addOrder(OrderModel order);
  Future<void> addToCart(AddToCartModel product);
  Future<void> addToFavorite(AddToFavoriteModel product);
  Future<void> deleteItemFromCart(AddToCartModel product);
  Future<void> deleteItemFromCarts(String uid, String productId);
  Future<void> deleteAllItemsFromCart(String uid);
  Future<void> deleteItemFromFavorite(AddToFavoriteModel product);
  Future<void> deleteItemFromDetails(AddToFavoriteModel product);
  Future<bool> isFavorite(String productId);

}

class FirestoreDatabase implements Database {
  final String uid;
  final services = FirestoreServices.instance;

  FirestoreDatabase(this.uid);

  @override
  Stream<List<Product>> salesProductsStream() {
    return services.collectionsStream(
      path: ApiPath.products(),
      builder: (data, documentId) => Product.fromMap(data!, documentId),
      queryBuilder: (query) => query.where('discountValue', isGreaterThan: 0),
    );
  }

  @override
  Stream<List<Product>> newProductsStream() {
    return services.collectionsStream(
      path: ApiPath.products(),
      builder: (data, documentId) => Product.fromMap(data!, documentId),
    );
  }

  @override
  Stream<List<Product>> productsByCategoryStream(String category) {
    return services.collectionsStream(
      path: ApiPath.products(),
      builder: (data, documentId) => Product.fromMap(data!, documentId),
      queryBuilder: (query) => query.where('category', isEqualTo: category),
    );
  }

  @override
  Future<void> setUserData(UserData userData) async => await services.setData(
        path: ApiPath.user(userData.uid),
        data: userData.toMap(),
      );

  @override
  Future<void> addToCart(AddToCartModel product) async =>
      await services.setData(
        path: ApiPath.addToCart(uid, product.id),
        data: product.toMap(),
      );

  @override
  Stream<List<AddToCartModel>> myProductsCart() => services.collectionsStream(
        path: ApiPath.myProductCart(uid),
        builder: (data, documentId) =>
            AddToCartModel.fromMap(data!, documentId),
      );

  @override
  Future<void> deleteItemFromCart(AddToCartModel product) async =>
      await services.deleteData(
        path: ApiPath.deleteProductFromCart(uid, product.id),
      );

  @override
  Future<void> addToFavorite(AddToFavoriteModel product) async =>
      await services.setData(
        path: ApiPath.addToFavorite(uid, product.id),
        data: product.toMap(),
      );

  @override
  Stream<List<AddToFavoriteModel>> myFavoriteCart() =>
      services.collectionsStream(
        path: ApiPath.myFavoriteCart(uid),
        builder: (data, documentId) =>
            AddToFavoriteModel.fromMap(data!, documentId),
      );

  @override
  Future<void> deleteItemFromFavorite(AddToFavoriteModel product) async =>
      await services.deleteData(
        path: ApiPath.deleteProductFromFavorite(uid, product.id),
      );

  @override
  Future<void> deleteItemFromDetails(AddToFavoriteModel product) async =>
      await services.deleteData(
        path: ApiPath.deleteProductFromDetails(uid, product.id),
      );

  @override
  Future<bool> isFavorite(String productId) async {
    final doc = await services.getDocument(
      path: ApiPath.addToFavorite(uid, productId),
    );
    return doc.exists;
  }

  @override
  Future<void> addProduct(Product product) async => await services.setData(
        path: ApiPath.addProduct(product.id),
        data: product.toMap(),
      );

  @override
  Future<void> addOrder(OrderModel order) async {
    return services.setData(
      path: ApiPath.addOrder(order.id),
      data: order.toMap(),
    );
  }

  @override
  Stream<List<AddToCartModel>> cartItems(String uid) {
    return services.collectionsStream(
      path: ApiPath.myProductCart(uid),
      builder: (data, documentId) => AddToCartModel.fromMap(data!, documentId),
    );
  }

  List<AddToCartModel> _cartItems = [];
  void fetchCartItems(String uid) {
    // Fetch items from Firestore and update _cartItems
    FirestoreServices.instance
        .collectionsStream(
      path: 'addToCart/$uid',
      builder: (data, documentId) => AddToCartModel.fromMap(data!, documentId),
    )
        .listen((items) {
      _cartItems = items;
     // notifyListeners();
    });
  }


  @override
  Future<void> deleteItemFromCarts(String uid, String productId) async {
    await services.deleteData(
      path: ApiPath.deleteProductFromCart(uid, productId),
    );
  }

  @override
  Future<void> deleteAllItemsFromCart(String uid) async {
    final cartItems = await services.documentsStream(
      path: ApiPath.myProductCart(uid),
      builder: (data, documentId) => AddToCartModel.fromMap(data!, documentId),
    ).toList();

    for (var item in cartItems) {
      await services.deleteData(
        path: ApiPath.deleteProductFromCart(uid, item.id),
      );
    }
  }
}