class ApiPath {
  static String products() => 'products/';
  static String user(String uid) => 'user/$uid';

  // Add Product
  static String addProduct(String AddProductToApp) => 'products/$AddProductToApp';

  // Cart
  static String addToCart(String uid, String addToCartId) => 'user/$uid/cart/$addToCartId';
  static String myProductCart(String uid) => 'user/$uid/cart/';
  static String deleteProductFromCart(String uid, String removeProductId) => 'user/$uid/cart/$removeProductId';

  // Favorite
  static String addToFavorite(String uid, String addToFavoriteId) => 'user/$uid/favorite/$addToFavoriteId';
  static String myFavoriteCart(String uid) => 'user/$uid/favorite/';
  static String deleteProductFromFavorite(String uid, String removeProductId) => 'user/$uid/favorite/$removeProductId';
  static String deleteProductFromDetails(String uid, String removeProductId) => 'user/$uid/favorite/$removeProductId';

  // Order
  static String addOrder(String AddOrderId) => 'order/$AddOrderId';
}